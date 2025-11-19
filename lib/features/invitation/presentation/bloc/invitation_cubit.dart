import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/invitation_model.dart';
import '../../domain/invitation_repository.dart';
import 'invitation_state.dart';

@injectable
class InvitationCubit extends Cubit<InvitationState> {
  InvitationRepository repository;
  InvitationCubit(this.repository) : super(InvitationInit());

  // create a list of invitaiton here

  void getInvitations(String params) async {
    try {
      emit(InvitationLoading());

      final response = await repository.getInvitations(params);

      emit(InvitationLoaded(response));
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  updateInvitationStatus(String id, Map<String, dynamic> data) async {
    try {
      final response = await repository.invitationAction(data, id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  void acceptInvitation(String id, Map<String, dynamic> data) async {
    try {
      emit(InvitationLoading());
      await updateInvitationStatus(id, data);
      emit(InvitationAccepted('Invitation accepted'));
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  void rejectInvitation(String id, int count) async {
    log('rejecting');
    try {
      emit(InvitationLoading());
      Map<String, dynamic> data = {
        "invitation_id": id,
        "attend_member_count": count,
        "guest_response_preferences": ["Not able to attend"]
      };
      await updateInvitationStatus(id, data);
      emit(InvitationRejected('Invitation rejected'));
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  void pendingInvitation(String id, int count) async {
    try {
      emit(InvitationLoading());
      Map<String, dynamic> data = {
        "invitation_id": id,
        "attend_member_count": count,
        "guest_response_preferences": ["Not sure to attend"]
      };
      await updateInvitationStatus(id, data);
      emit(InvitationPending('Invitation pending'));
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  void getFamilies() async {
    try {
      emit(InvitationLoading());
      final response = await repository.getFamilies();
      emit(FamilyLoaded(response));
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }
}
