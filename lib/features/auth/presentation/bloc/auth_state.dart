import '../../../profile/data/model/city_model.dart';
import '../../../profile/data/model/state_model.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthSuccess extends AuthState {
  final String success;
  AuthSuccess(this.success);
}

class AuthSignupSuccess extends AuthState {
  final String success;
  AuthSignupSuccess(this.success);
}

class OtpSuccess extends AuthState {
  final String success;
  OtpSuccess(this.success);
}

class StateLoading extends AuthState {}

class StateLoaded extends AuthState {
  final StateModel states;
  StateLoaded(this.states);
}

class CityLoaded extends AuthState {
  final CityModel cities;
  CityLoaded(this.cities);
}
