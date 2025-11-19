import '../../data/model/Profile_loaded.dart';
import '../../data/model/city_model.dart';
import '../../data/model/community_model.dart';
import '../../data/model/religion_model.dart';
import '../../data/model/state_model.dart';

sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);
}

class ProfileUpdateFailure extends ProfileState {
  final String message;
  ProfileUpdateFailure(this.message);
}

class ProfileSuccess extends ProfileState {
  final String message;
  ProfileSuccess(this.message);
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;
  ProfileUpdateSuccess(this.message);
}

class ProfileUpdateLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  final ReligionModel? religion;
  final StateModel? state;
  ProfileLoaded(this.profile, this.religion, this.state);
}

class CityLoaded extends ProfileState {
  final CityModel city;
  CityLoaded(this.city);
}

class CommunityLoaded extends ProfileState {
  final CommunityModel community;
  CommunityLoaded(this.community);
}
