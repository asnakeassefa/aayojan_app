import 'dart:math';

import 'package:aayojan/features/plan_event/data/datasource/event_data_source.dart';
import 'package:aayojan/features/plan_event/data/model/event_detail_model.dart';
import 'package:aayojan/features/plan_event/domain/plan_event_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PlanEventRepository)
class PlanEventRepositoryImpl implements PlanEventRepository {
  final EventDataSource dataSource;
  PlanEventRepositoryImpl(this.dataSource);

  @override
  Future<Map<String,dynamic>> addEvent(Map<String, dynamic> data) async {
    try {
      final response = await dataSource.addEvent(data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteEvent() {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }

  @override
  Future<String> updateEvent(Map<String, dynamic> data, String id) async {
    try {
      final response = await dataSource.updateEvent(data, id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<EventDetailModel> getEventDetails(String id) async {
    try {
      final response = await dataSource.getEventDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getEvents() {
    // TODO: implement getEvents
    throw UnimplementedError();
  }
}
