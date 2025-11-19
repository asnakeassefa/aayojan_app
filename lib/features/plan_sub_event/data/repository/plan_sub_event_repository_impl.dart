import 'package:aayojan/features/my_event/data/model/event_model.dart';
import 'package:aayojan/features/my_event/data/model/sub_event_detail_model.dart';
import 'package:aayojan/features/plan_sub_event/data/model/sub_event_guest_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/plan_sub_event_repository.dart';
import '../datasource/sub_event_data_source.dart';

@Injectable(as: PlanSubEventRepository)
class PlanSubEventRepositoryImpl implements PlanSubEventRepository {
  SubEventDataSource dataSource;
  PlanSubEventRepositoryImpl(this.dataSource);

  @override
  Future<String> addSubEvent(Map<String, dynamic> data) {
    try {
      return dataSource.addSubEvent(data);
    } catch (e) {
      rethrow;
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
      return await dataSource.getSubEventDetails(id);
    } catch (e) {
      rethrow;
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
      return await dataSource.getEvents();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateSubEvent(Map<String, dynamic> data, String id) async {
    try {
      return await dataSource.updateSubEvent(data, id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SubEventGuestModel> getSubEventGuests(String mainEventId, String subEventId) {
    try {
      return dataSource.getSubEventGuests(mainEventId, subEventId);
    } catch (e) {
      rethrow;
    }
  }
}
