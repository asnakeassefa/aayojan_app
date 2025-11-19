import 'package:aayojan/features/my_event/data/model/event_model.dart';
import 'package:aayojan/features/my_event/data/model/sub_event_model.dart';

abstract class EventRepository {
  Future<EventModel> getMyEvents(String word);
  Future<EventModel> getEventsByParam();
  Future<String> updateEvent(String id, Map<String, dynamic> data);
  Future<String> deleteEvent(String id);
  Future<String> deleteSubEvent(String id);
  Future<SubEventModel> getSubEventsByParam(String mainEventId);
}
