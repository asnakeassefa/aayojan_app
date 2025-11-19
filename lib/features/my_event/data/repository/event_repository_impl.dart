import 'package:aayojan/features/my_event/data/data_source/remote_data_source.dart';
import 'package:aayojan/features/my_event/data/model/event_model.dart';
import 'package:aayojan/features/my_event/data/model/sub_event_model.dart';
import 'package:aayojan/features/plan_sub_event/presentation/bloc/sub_event_cubit.dart';
import 'package:injectable/injectable.dart';

import '../../domain/event_repository.dart';

@Injectable(as: EventRepository)
class EventRepositoryImpl implements EventRepository {
  // data source
  final EventRemoteDataSource dataSource;
  EventRepositoryImpl(this.dataSource);

  @override
  Future<EventModel> getEventsByParam() async {
    // TODO: implement getEventsByParam
    throw UnimplementedError();
  }

  @override
  Future<EventModel> getMyEvents(String word) async {
    try {
      return await dataSource.getMyEvents(word);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateEvent(String id, Map<String, dynamic> data) async {
    // TODO: implement updateEvent
    throw UnimplementedError();
  }

  @override
  Future<String> deleteEvent(String id) async {
    try {
      return await dataSource.deleteEvent(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SubEventModel> getSubEventsByParam(String mainEventId) async {
    try {
      return await dataSource.getSubEventsByParam(mainEventId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteSubEvent(String id) async {
    try {
      return await dataSource.deleteSubEvent(id);
    } catch (e) {
      rethrow;
    }
  }
}
