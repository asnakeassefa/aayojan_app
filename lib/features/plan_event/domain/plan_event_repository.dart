import '../data/model/event_detail_model.dart';

abstract class PlanEventRepository {
  Future<Map<String,dynamic>> addEvent(Map<String, dynamic> data);
  Future<String> deleteEvent();
  Future<String> updateEvent(Map<String, dynamic> data, String id);
  Future<String> getEvents();
  Future<EventDetailModel> getEventDetails(String id);
}
