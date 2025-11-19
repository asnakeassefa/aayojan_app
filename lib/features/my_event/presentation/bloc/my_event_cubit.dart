import 'package:aayojan/features/my_event/domain/event_repository.dart';
import 'package:aayojan/features/my_event/presentation/bloc/my_event_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MyEventCubit extends Cubit<MyEventState> {
  final EventRepository repository;
  MyEventCubit(this.repository) : super(MyEventInit());
  void getEvents() async {
    emit(MyeventLoading());
    try {
      final response = await repository.getMyEvents("");
      emit(MyEventLoaded(response));
    } catch (e) {
      emit(MyEventFailure(e.toString()));
    }
  }

  void getSubEvents(String mainId) async {
    emit(MyeventLoading());
    try {
      final response = await repository.getSubEventsByParam(mainId);
      emit(MySubEventLoaded(response));
    } catch (e) {
      emit(MyEventFailure(e.toString()));
    }
  }

  void searchEvent(String word) async {
    emit(MyeventLoading());
    try {
      final response = await repository.getMyEvents(word);
      emit(MyEventLoaded(response));
    } catch (e) {
      emit(MyEventFailure(e.toString()));
    }
  }

  void updateEvent(String id, Map<String, dynamic> data) async {
    emit(MyeventLoading());
    try {
      final response = await repository.updateEvent(id, data);
      emit(MyEventUpdated(response));
    } catch (e) {
      emit(MyEventFailure(e.toString()));
    }
  }

  void deleteEvent(String id) async {
    emit(MyeventLoading());
    try {
      final response = await repository.deleteEvent(id);
      emit(MyEventDeleted(response));
    } catch (e) {
      emit(MyEventFailure(e.toString()));
    }
  }

  void deleteSubEvent(String id) async {
    emit(MyeventLoading());
    try {
      final response = await repository.deleteSubEvent(id);
      emit(MySubEventDeleted(response));
    } catch (e) {
      emit(MyEventFailure(e.toString()));
    }
  }
}
