import 'dart:developer';

import 'package:aayojan/core/network/api_provider.dart';
import 'package:aayojan/core/network/endpoints.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../model/event_model.dart';
import '../model/sub_event_model.dart';

abstract class EventRemoteDataSource {
  Future<EventModel> getMyEvents(String params);
  Future<EventModel> getEventsByParam();
  Future<String> updateEvent(String id, Map<String, dynamic> data);
  Future<String> deleteEvent(String id);
  Future<String> deleteSubEvent(String id);
  Future<SubEventModel> getSubEventsByParam(String mainEventId);
}

@Injectable(as: EventRemoteDataSource)
class RemoteDataSourceImpl implements EventRemoteDataSource {
  ApiService api = ApiService();
  @override
  Future<EventModel> getEventsByParam() {
    // TODO: implement getEventsByParam
    throw UnimplementedError();
  }

  @override
  Future<EventModel> getMyEvents(String params) async {
    try {
      final response = await api.get("${Endpoints.getEvents}?search=$params");
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
  Future<String> updateEvent(String id, Map<String, dynamic> data) async {
    try {
      final response = await api.post('${Endpoints.updateEvent}/$id', data);

      return response.data['message'];
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
  Future<String> deleteEvent(String id) async {
    try {
      final response = await api.delete('${Endpoints.deleteEvent}/$id');

      return response.data['message'];
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
  Future<SubEventModel> getSubEventsByParam(String mainEventId) async {
    try {
      final response =
          await api.get('${Endpoints.getSubEvents}?main_event_id=$mainEventId');

      return SubEventModel.fromJson(response.data);
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
  Future<String> deleteSubEvent(String id) async {
    try {
      final response = await api.delete('${Endpoints.deleteSubEvent}/$id');
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
