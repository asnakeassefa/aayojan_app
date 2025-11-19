import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/plan_sub_event_repository.dart';
import 'sub_event_state.dart';

@injectable
class SubEventCubit extends Cubit<SubEventState> {
  final PlanSubEventRepository repository;
  SubEventCubit(this.repository) : super(SubEventInit());

  void getEvents() async {
    emit(SubEventLoading());
    try {
      emit(SubEventLoading());
      log('here');
      final response = await repository.getEvents();
      log(response.toString());
      emit(MyEventLoaded(response));
    } catch (e) {
      emit(SubEventFailure(message: e.toString()));
    }
  }

  void getSubEvents(String eventId) async {
    emit(SubEventLoading());
    try {
      final response = await repository.getSubEventDetails(eventId);
      emit(SubEventLoaded(response));
    } catch (e) {
      emit(SubEventFailure(message: e.toString()));
    }
  }

  void addSubEvent(Map<String, dynamic> data) async {
    emit(SubEventLoading());
    try {
      log(data.toString());
      final response = await repository.addSubEvent(data);
      emit(SubEventSuccess(message: response));
    } catch (e) {
      emit(SubEventFailure(message: e.toString()));
    }
  }

  void updateSubEvent(Map<String, dynamic> data, String id) async {
    emit(SubEventLoading());
    try {
      final response = await repository.updateSubEvent(data, id);
      emit(SubEventSuccess(message: response));
    } catch (e) {
      emit(SubEventFailure(message: e.toString()));
    }
  }

  void getSubEventGuests(String mainEventId, String subEventId) async {
    emit(SubEventGuestLoading());
    try {
      final response = await repository.getSubEventGuests(mainEventId, subEventId);
      emit(SubEventGuestsLoaded(response));
    } catch (e) {
      emit(SubEventFailure(message: e.toString()));
    }
  }
}
