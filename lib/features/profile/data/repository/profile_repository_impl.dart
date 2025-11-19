import 'package:aayojan/features/profile/data/model/Profile_loaded.dart';
import 'package:aayojan/features/profile/data/model/city_model.dart';
import 'package:aayojan/features/profile/data/model/community_model.dart';
import 'package:aayojan/features/profile/data/model/religion_model.dart';
import 'package:aayojan/features/profile/data/model/state_model.dart';
import 'package:aayojan/features/profile/domain/profile_repository.dart';
import 'package:injectable/injectable.dart';

import '../datasource/profile_data_source.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileDataSource dataSource;
  ProfileRepositoryImpl(this.dataSource);
  @override
  Future<ProfileModel> getProfile() async {
    try {
      return await dataSource.getProfile();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateProfile(Map<String, dynamic> data) async {
    try {
      return await dataSource.updateProfile(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReligionModel> getReligion() async {
    try {
      return await dataSource.getReligion();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CityModel> getCity(String stateId) {
    try {
      return dataSource.getCity(stateId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<StateModel> getState() async {
    try {
      return await dataSource.getState();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CommunityModel> getCommnity(String religionId) async {
    try {
      return await dataSource.getCommunity(religionId);
    } catch (e) {
      rethrow;
    }
  }
}
