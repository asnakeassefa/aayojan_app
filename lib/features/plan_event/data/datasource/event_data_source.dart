import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_provider.dart';
import '../../../../core/network/endpoints.dart';
import '../model/event_detail_model.dart';

abstract class EventDataSource {
  Future<Map<String, dynamic>> addEvent(Map<String, dynamic> data);
  Future<String> deleteEvent(String id);
  Future<String> updateEvent(Map<String, dynamic> data, String id);
  Future<String> getEvents();
  Future<EventDetailModel> getEventDetails(String id);
}

@Injectable(as: EventDataSource)
class EventDataSourceImpl implements EventDataSource {
  ApiService api = ApiService();
  @override
  Future<Map<String, dynamic>> addEvent(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(
        {
          'title': data['title'],
          'event_type': data['event_type'],
          'venue': data['venue'],
          'start_date': data['start_date'],
          'end_date': data['end_date'],
          'time': data['time'],
          'details': data['details'],
        },
      );

      String? image = data['document'];
      List<String> types = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'pdf', 'docs'];
      if (image != null && image.isNotEmpty) {
        final extension = image.split('.').last.toLowerCase();
        if (!types.contains(extension)) {
          throw Exception('Invalid image type');
        }
        formData.files.add(
          MapEntry(
            'document',
            await MultipartFile.fromFile(
              image,
              filename: 'document.$extension',
              contentType: MediaType('image', extension),
            ),
          ),
        );
      }

      final response = await api.upload(Endpoints.createEvent, formData);
      final int? save = data['save'];
      final guestFormData = FormData.fromMap(
        {
          'main_event_id': response.data['data']['id'],
          'showList': save,
        },
      );

      for (var id in data['guests']) {
        guestFormData.fields.add(MapEntry("guests[]", id.toString()));
      }

      log(guestFormData.fields.toString());

      final guestReponse = await api.upload(
        Endpoints.saveGuests,
        guestFormData,
      );

      return {
        'message': response.data['message'],
        'id': response.data['data']['id'],
      };
    } catch (e) {
      log(e.toString());
      if (e is ClientException) {
        rethrow;
      } else if (e is ServerException) {
        rethrow;
      } else {
        throw 'Something went wrong';
      }
    }
  }

  @override
  Future<String> deleteEvent(String id) {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }

  @override
  Future<EventDetailModel> getEventDetails(String id) async {
    try {
      final response = await api.get("${Endpoints.getEventDetails}/$id");
      final res = EventDetailModel.fromJson(response.data);
      return res;
    } catch (e) {
      log(e.toString());
      if (e is ClientException) {
        rethrow;
      } else if (e is ServerException) {
        rethrow;
      } else {
        throw 'Something went wrong';
      }
    }
  }

  @override
  Future<String> getEvents() {
    // TODO: implement getEvents
    throw UnimplementedError();
  }

  @override
  Future<String> updateEvent(Map<String, dynamic> data, String id) async {
    try {
      final formData = FormData.fromMap(
        {
          'title': data['title'],
          'event_type': data['event_type'],
          'venue': data['venue'],
          'start_date': data['start_date'],
          'end_date': data['end_date'],
          'time': data['time'],
          'details': data['details'],
          'guests': data['guests'],
        },
      );
      log(data['document'].toString());
      String? image = data['document'];
      List<String> types = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'pdf', 'docs'];
      if (image != null && image.isNotEmpty) {
        final extension = image.split('.').last.toLowerCase();
        if (!types.contains(extension)) {
          throw ClientException(message: 'Invalid image type');
        }
        formData.files.add(
          MapEntry(
            'document',
            await MultipartFile.fromFile(
              image,
              filename: 'document.$extension',
              contentType: MediaType('image', extension),
            ),
          ),
        );
      }
      final response =
          await api.upload("${Endpoints.updateEvent}/$id", formData);

      final int? save = data['save'];
      final guestFormData = FormData.fromMap(
        {
          'main_event_id': id,
          'showList': save,
        },
      );

      for (var id in data['guests']) {
        guestFormData.fields.add(MapEntry("guests[]", id.toString()));
      }

      log(guestFormData.fields.toString());

      final guestReponse = await api.upload(
        Endpoints.saveGuests,
        guestFormData,
      );

      return response.data['message'];
    } catch (e) {
      log(e.toString());
      if (e is ClientException) {
        rethrow;
      } else if (e is ServerException) {
        rethrow;
      } else {
        throw 'Something went wrong';
      }
    }
  }
}
