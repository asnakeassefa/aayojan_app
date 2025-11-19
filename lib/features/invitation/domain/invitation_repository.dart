import 'package:aayojan/features/invitation/data/model/invitation_model.dart';
import 'package:aayojan/features/manage_family/data/model/family_model.dart';

abstract class InvitationRepository {
  Future<InvitationModel> getInvitations(String parmas);
  Future<String> invitationAction(Map<String, dynamic> data, String id);
  Future<String> getGuests();
  Future<FamilyModel> getFamilies();
}
