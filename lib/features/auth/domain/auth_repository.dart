import '../../profile/data/model/city_model.dart';
import '../../profile/data/model/state_model.dart';

abstract class AuthRepository {
  Future<String> signIn(Map<String, String> data);
  Future<String> signUp(Map<String, dynamic> data);

  Future<String> verifyOTP(Map<String, String> data);
  Future<String> sendOTP(String phone);
  Future<String> resendOTP(String phone);

  Future<StateModel> getState();
  Future<CityModel> getCities(String stateId);
}
