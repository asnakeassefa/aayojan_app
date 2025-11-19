import 'package:aayojan/features/my_event/data/model/sub_event_detail_model.dart';
import 'package:aayojan/features/my_event/data/model/sub_event_model.dart';

import '../../my_event/data/model/event_model.dart';
import '../data/model/sub_event_guest_model.dart';

abstract class PlanSubEventRepository {
  Future<String> addSubEvent(Map<String, dynamic> data);
  Future<String> deleteSubEvent();
  Future<String> updateSubEvent(Map<String, dynamic> data, String id);
  Future<String> getSubEvents();
  Future<SubEventDetailModel> getSubEventDetails(String id);
  Future<EventModel> getEvents();
  Future<SubEventGuestModel> getSubEventGuests(String mainEventId,String subEventId);
}
