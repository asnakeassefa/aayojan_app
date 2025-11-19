import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../notification/data/service/flutter_service.dart';
import '../../domain/auth_repository.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthRepository authRepository;
  AuthCubit(this.authRepository) : super(AuthInitial());

  void signIn(String phoneNumber) async {
    emit(AuthLoading());
    try {
      final deviceToken = await FirebaseService().getToken();
      final response = await authRepository
          .signIn({"phone": phoneNumber, "device_token": deviceToken ?? ""});
      emit(AuthSuccess(response));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void signUp(Map<String, dynamic> data) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.signUp(data);
      emit(AuthSignupSuccess(response));
    } catch (e) {
      log(e.toString());
      emit(AuthFailure(e.toString()));
    }
  }

  void verifyOTP(String phoneNumber, String otp) async {
    emit(AuthLoading());
    try {
      final deviceToken = await FirebaseService().getToken();
      final response = await authRepository.verifyOTP({
        "phone": phoneNumber,
        "otp": otp,
        "device_token": deviceToken ?? ""
      });
      emit(OtpSuccess(response));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void sendOTP(String phone) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.sendOTP(phone);
      emit(AuthSuccess(response));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void resendOTP(String phone) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.resendOTP(phone);
      emit(AuthSuccess(response));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void getStates() async {
    emit(StateLoading());
    try {
      final response = await authRepository.getState();
      emit(StateLoaded(response));
    } catch (e) {
      log(e.toString());
      // emit(AuthFailure(e.toString()));
    }
  }

  void getCities(String stateId) async {
    emit(StateLoading());
    try {
      final response = await authRepository.getCities(stateId);
      emit(CityLoaded(response));
    } catch (e) {
      log(e.toString());
      // emit(AuthFailure(e.toString()));
    }
  }
}
