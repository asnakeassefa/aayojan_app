import 'dart:developer';

import 'package:aayojan/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/profile_repository.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  ProfileCubit(this.profileRepository) : super(ProfileInitial());

  void getProfile() async {
    try {
      emit(ProfileLoading());
      final response = await profileRepository.getProfile();
      final religionResponse = await profileRepository.getReligion();
      final states = await profileRepository.getState();
      emit(ProfileLoaded(response, religionResponse, states));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  void getOnlyProfile() async{
    try {
      emit(ProfileLoading());
      final response = await profileRepository.getProfile();
      emit(ProfileLoaded(response, null, null));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  void updateProfile(Map<String, dynamic> data) async {
    try {
      emit(ProfileUpdateLoading());
      final response = await profileRepository.updateProfile(data);
      emit(ProfileUpdateSuccess(response));
    } catch (e) {
      log(e.toString());
      emit(ProfileUpdateFailure(e.toString()));
    }
  }

  void getCities(String stateId) async {
    log('here in city');
    try {
      emit(ProfileLoading());
      final response = await profileRepository.getCity(stateId);
      emit(CityLoaded(response));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  void getCommunites(String religionId) async {
    try {
      emit(ProfileLoading());
      final response =
          await profileRepository.getCommnity(religionId);
      emit(CommunityLoaded(response));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}
