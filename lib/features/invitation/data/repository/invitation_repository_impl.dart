import 'package:aayojan/features/invitation/data/model/invitation_model.dart';
import 'package:injectable/injectable.dart';

import '../../../manage_family/data/model/family_model.dart';
import '../../domain/invitation_repository.dart';
import '../datasource/invitation_data_source.dart';

@Injectable(as: InvitationRepository)
class InvitationRepositoryImpl implements InvitationRepository {
  InvitationDataSource dataSource;
  InvitationRepositoryImpl(this.dataSource);

  @override
  Future<String> getGuests() {
    // TODO: implement getGuests
    throw UnimplementedError();
  }

  @override
  Future<InvitationModel> getInvitations(String params) async {
    try {
      return await dataSource.getInvitations(params);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> invitationAction(Map<String, dynamic> data, String id) async {
    try {
      return await dataSource.invitationAction(data, id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FamilyModel> getFamilies() async {
    try {
      return await dataSource.getFamilies();
    } catch (e) {
      rethrow;
    }
  }
}
