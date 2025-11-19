import 'dart:developer';

import 'package:aayojan/features/profile/data/model/religion_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../profile/data/model/state_model.dart';
import '../../domain/guest_repository.dart';
import 'guest_state.dart';

@injectable
class GuestCubit extends Cubit<GuestState> {
  GuestRepository repository;
  GuestCubit(this.repository) : super(GuestInit());

  void getRelations() async {
    try {
      emit(GuestLoading());
      final category = await repository.getCategory();
      final StateModel states = await repository.getState();

      emit(RelationLoaded(states, category));
    } catch (e) {
      emit(GuestFailure(e.toString()));
    }
  }

  void getCity(String id) async {
    try {
      emit(CityLoading());
      final response = await repository.getCity(id);
      emit(CityLoaded(response));
    } catch (e) {
      emit(GuestFailure(e.toString()));
    }
  }

  void addGuest(Map<String, dynamic> data) async {
    try {
      emit(GuestAddLoading());
      final response = await repository.addGuest(data);
      emit(GuestSuccess(response));
    } catch (e) {
      emit(GuestFailure(e.toString()));
    }
  }

  void searchGuests(String query) async {
    try {
      emit(GuestLoading());
      final response = await repository.searchGuests(query);
      emit(GuestLoaded(response, null));
    } catch (e) {
      emit(GuestFailure(e.toString()));
    }
  }

  void getGuests(int? id) async {
    try {
      log('here in guest cubit');
      emit(GuestLoading());
      final response = await repository.getGuests();
      if (id != null) {
        log('here in guest cubit sub event');
        final subEventResponse = await repository.getEventGuests(id.toString());
        log('sub event response: ${subEventResponse.data?.length}');
        emit(GuestLoaded(response, subEventResponse));
      } else {
        emit(GuestLoaded(response, null));
      }
    } catch (e) {
      log('error in guest cubit: $e');
      emit(GuestFailure(e.toString()));
    }
  }

  void addGuestCsv(Map<String, String> data) async {
    try {
      emit(GuestAddLoading());
      final response = await repository.uploadExcelFile(data);
      emit(GuestSuccess(response));
    } catch (e) {
      emit(GuestFailure(e.toString()));
    }
  }

  void editGuest(Map<String, dynamic> data, String id) async {
    try {
      emit(GuestAddLoading());
      final response = await repository.editGuest(data, id);
      emit(GuestSuccess(response));
    } catch (e) {
      emit(GuestFailure(e.toString()));
    }
  }

  void deleteGuest(String id) async {
    try {
      emit(GuestLoading());
      final response = await repository.deleteGuest(id);
      emit(GuestSuccess(response));
    } catch (e) {
      emit(GuestFailure(e.toString()));
    }
  }

  void getGuest(String id) async {
    try {
      emit(SingleGuestLoading());
      final response = await repository.getGuest(id);
      emit(GuestSingleLoaded(response));
    } catch (e) {
      emit(GuestFailure(e.toString()));
    }
  }

  void getEventGuests(String id) async {
    try {
      emit(GuestLoading());
      final response = await repository.getEventGuests(id);
      emit(EventGuestsLoaded(response));
    } catch (e) {
      emit(GuestFailure(e.toString()));
    }
  }

  void getGuestByPhone(String phone) async {
    try {
      emit(GuestWithPhoneLoading());
      final response = await repository.getGuestByPhone(phone);
      emit(GuestWithPhoneLoaded(response));
    } catch (e) {
      emit(GuestWithPhoneFailure(e.toString()));
    }
  }

  void getFamilyMembers(String id) async {
    try {
      emit(FamilyMembersLoading());
      final response = await repository.getFamilyMembers(id);
      emit(FamilyMembersLoaded(response));
    } catch (e) {
      emit(FamilyMembersFailure(e.toString()));
    }
  }
}
