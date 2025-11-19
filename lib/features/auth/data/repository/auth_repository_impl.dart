import 'package:aayojan/features/profile/data/model/city_model.dart';
import 'package:aayojan/features/profile/data/model/state_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/check_internet.dart';
import '../../domain/auth_repository.dart';
import '../data_source/remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final CheckInternet checkInternet;
  AuthRepositoryImpl(
      {required this.authRemoteDataSource, required this.checkInternet});
  @override
  Future<String> sendOTP(String phone) async {
    try {
      final connectionState = await checkInternet.hasInternetConnection();
      if (!connectionState) {
        throw Exception("No Internet Connection");
      } else {
        return authRemoteDataSource.sendOTP(phone);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> signIn(Map<String, String> data) async {
    try {
      final connectionState = await checkInternet.hasInternetConnection();
      if (!connectionState) {
        throw Exception("No Internet Connection");
      } else {
        return authRemoteDataSource.signIn(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> signUp(Map<String, dynamic> data) async {
    try {
      final connectionState = await checkInternet.hasInternetConnection();
      if (!connectionState) {
        throw Exception("No Internet Connection");
      } else {
        return authRemoteDataSource.signUp(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> verifyOTP(Map<String, String> data) async {
    try {
      final connectionState = await checkInternet.hasInternetConnection();
      if (!connectionState) {
        throw Exception("No Internet Connection");
      } else {
        return authRemoteDataSource.verifyOTP(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> resendOTP(String phone) async {
    try {
      final connectionState = await checkInternet.hasInternetConnection();
      if (!connectionState) {
        throw Exception("No Internet Connection");
      } else {
        return await authRemoteDataSource.resendOTP(phone);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CityModel> getCities(String stateId) async {
    try {
      final connectionState = await checkInternet.hasInternetConnection();
      if (!connectionState) {
        throw Exception("No Internet Connection");
      } else {
        return await authRemoteDataSource.getCities(stateId);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<StateModel> getState() async {
    try {
      final connectionState = await checkInternet.hasInternetConnection();
      if (!connectionState) {
        throw Exception("No Internet Connection");
      } else {
        return await authRemoteDataSource.getState();
      }
    } catch (e) {
      rethrow;
    }
  }
}
