import 'dart:developer';

import 'package:aayojan/core/network/api_provider.dart';
import 'package:aayojan/features/my_event/data/model/event_model.dart';
import 'package:aayojan/features/my_event/data/model/sub_event_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/endpoints.dart';
import '../model/sub_event_guest_model.dart';

abstract class SubEventDataSource {
  Future<String> addSubEvent(Map<String, dynamic> data);
  Future<String> deleteSubEvent();
  Future<String> updateSubEvent(Map<String, dynamic> data, String id);
  Future<String> getSubEvents();
  Future<SubEventDetailModel> getSubEventDetails(String id);
  Future<EventModel> getEvents();
  Future<SubEventGuestModel> getSubEventGuests(
      String mainEventId, String subEventId);
}

@Injectable(as: SubEventDataSource)
class SubEventDataSourceImpl implements SubEventDataSource {
  ApiService apiService = ApiService();
  @override
  Future<String> addSubEvent(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(
        {
          'event_name': data['event_name'],
          'description': data['description'],
          'time': data['time'],
          'date': data['date'],
          'venue': data['venue'],
          'main_event_id': data['main_event_id'],
          'times_of_day': data['times_of_day'],
          'guest_response_preferences': ['g'],
        },
      );

      for (var id in data['guests_id']) {
        formData.fields.add(MapEntry("guests_id[]", id.toString()));
      }

      String? image = data['document'];
      List<String> types = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'pdf'];
      if (image != null) {
        final extension = image.split('.').last.toLowerCase();
        log(extension.toString());
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

      final response =
          await apiService.upload(Endpoints.createSubEvent, formData);

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

  @override
  Future<String> deleteSubEvent() {
    // TODO: implement deleteSubEvent
    throw UnimplementedError();
  }

  @override
  Future<SubEventDetailModel> getSubEventDetails(String id) async {
    try {
      final response =
          await apiService.get('${Endpoints.getSubEventDetails}/$id');
      return SubEventDetailModel.fromJson(response.data);
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
  Future<String> getSubEvents() {
    // TODO: implement getSubEvents
    throw UnimplementedError();
  }

  @override
  Future<EventModel> getEvents() async {
    try {
      final response = await apiService.get(Endpoints.getEvents);
      return EventModel.fromJson(response.data);
    } catch (e) {
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
  Future<String> updateSubEvent(Map<String, dynamic> data, String id) async {
    try {
      final formData = FormData.fromMap(
        {
          'event_name': data['event_name'],
          'description': data['description'],
          'time': data['time'],
          'date': data['date'],
          'venue': data['venue'],
          'main_event_id': data['main_event_id'],
          'times_of_day': data['times_of_day'],
          'guest_response_preferences': ['g'],
        },
      );

      for (var id in data['guests_id']) {
        formData.fields.add(MapEntry("guests_id[]", id.toString()));
      }

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

      final response =
          await apiService.upload('${Endpoints.updateSubEvent}/$id', formData);

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

  @override
  Future<SubEventGuestModel> getSubEventGuests(
      String mainEventId, String subEventId) async {
    try {
      final response =
          await apiService.get('${Endpoints.getSubEventGuests}/$subEventId');
      return SubEventGuestModel.fromJson(response.data);
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
