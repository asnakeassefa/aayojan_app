import 'dart:developer';

import 'package:aayojan/core/network/api_provider.dart';
import 'package:aayojan/features/invitation/data/model/invitation_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/endpoints.dart';
import '../../../manage_family/data/model/family_model.dart';

abstract class InvitationDataSource {
  Future<InvitationModel> getInvitations(String params);
  Future<String> invitationAction(Map<String, dynamic> data, String id);
  Future<String> getGuests();
  Future<FamilyModel> getFamilies();
}

@Injectable(as: InvitationDataSource)
class InvitationDataSourceImpl implements InvitationDataSource {
  ApiService apiService = ApiService();
  @override
  Future<String> getGuests() {
    // TODO: implement getGuests
    throw UnimplementedError();
  }

  @override
  Future<InvitationModel> getInvitations(String params) async {
    try {
      log(params);
      final response =
          await apiService.get("${Endpoints.invitation}?search=$params");
      final invitations = InvitationModel.fromJson(response.data);
      return invitations;
    } catch (e) {
      if (e is ClientException) {
        rethrow;
      } else if (e is ServerException) {
        rethrow;
      } else {
        throw 'Something went wrong';
      }
    }
  }

  @override
  Future<String> invitationAction(Map<String, dynamic> data, String id) async {
    try {
      final response = await apiService.post(Endpoints.invitationAction, data);
      return response.data['message'];
    } catch (e) {
      if (e is ClientException) {
        rethrow;
      } else if (e is ServerException) {
        rethrow;
      } else {
        throw 'Something went wrong';
      }
    }
  }

  @override
  Future<FamilyModel> getFamilies() async {
    try {
      final response = await apiService.get(Endpoints.getFamilies);
      final families = FamilyModel.fromJson(response.data);
      return families;
    } catch (e) {
      if (e is ClientException) {
        rethrow;
      } else if (e is ServerException) {
        rethrow;
      } else {
        throw 'Something went wrong';
      }
    }
  }
}
