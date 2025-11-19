import 'package:aayojan/features/invitation/data/model/invitation_model.dart';
import 'package:aayojan/features/manage_family/data/model/family_model.dart';

sealed class InvitationState {}

class InvitationInit extends InvitationState {}

class InvitationLoading extends InvitationState {}

class InvitationLoaded extends InvitationState {
  final InvitationModel invitation;
  InvitationLoaded(this.invitation);
}

class InvitationFailure extends InvitationState {
  final String message;
  InvitationFailure(this.message);
}

class InvitationSuccess extends InvitationState {
  final String message;
  InvitationSuccess(this.message);
}

class InvitationAccepted extends InvitationState {
  final String message;
  InvitationAccepted(this.message);
}

class InvitationRejected extends InvitationState {
  final String message;
  InvitationRejected(this.message);
}

class InvitationPending extends InvitationState {
  final String message;
  InvitationPending(this.message);
}

class FamilyLoaded extends InvitationState {
  final FamilyModel family;
  FamilyLoaded(this.family);
}
