import 'package:aayojan/features/profile/data/model/Profile_loaded.dart';
import 'package:aayojan/features/profile/data/model/city_model.dart';
import 'package:aayojan/features/profile/data/model/community_model.dart';
import 'package:aayojan/features/profile/data/model/religion_model.dart';
import 'package:aayojan/features/profile/data/model/state_model.dart';

abstract class ProfileRepository {
  Future<String> updateProfile(Map<String, dynamic> data);
  Future<ProfileModel> getProfile();
  Future<ReligionModel> getReligion();
  Future<CityModel> getCity(String stateId);
  Future<StateModel> getState();
  Future<CommunityModel> getCommnity(String religionId);
}
