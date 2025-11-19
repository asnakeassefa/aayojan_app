import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/plan_event_repository.dart';
import 'plan_event_state.dart';

@injectable
class PlanEventCubit extends Cubit<PlanEventState> {
  PlanEventRepository repository;
  PlanEventCubit(this.repository) : super(PlanEventInit());

  void createEvent(Map<String, dynamic> data, bool withSubEvent) async {
    if (withSubEvent) {
      emit(PlanEventLoadingWithSubEvent());
    } else {
      emit(PlanEventLoading());
    }
    try {
      log(data.toString());
      Map<String, dynamic> response = await repository.addEvent(data);
      log(response.toString());
      if (withSubEvent) {
        emit(PlanEventSuccessWithSubEvent(
            message: response['message'], id: response['id']));
      } else {
        emit(PlanEventSuccess(message: response['message']));
      }
    } catch (e) {
      log('here in cubit');
      emit(PlanEventFailure(message: e.toString()));
    }
  }

  void getEventDetails(String id) async {
    emit(EventLoading());
    try {
      final response = await repository.getEventDetails(id);

      emit(EventLoaded(response));
    } catch (e) {
      log(e.toString());
      emit(PlanEventFailure(message: e.toString()));
    }
  }

  void updateEvent(Map<String, dynamic> data, int id, bool withSubEvent) async {
    if (withSubEvent) {
      emit(PlanEventLoadingWithSubEvent());
    } else {
      emit(PlanEventLoading());
    }

    try {
      if (withSubEvent) {
        String response = await repository.updateEvent(data, id.toString());
        emit(PlanEventSuccessWithSubEvent(message: response, id: id));
      } else {
        String response = await repository.updateEvent(data, id.toString());
        emit(PlanEventSuccess(message: response));
      }
    } catch (e) {
      emit(PlanEventFailure(message: e.toString()));
    }
  }

  void SaveGuests(Map<String, dynamic> data) async {
    emit(PlanEventLoading());
    try {
      // String response = await repository.saveGuests(data);
      // emit(PlanEventSuccess(message: response));
    } catch (e) {
      emit(PlanEventFailure(message: e.toString()));
    }
  }
}
