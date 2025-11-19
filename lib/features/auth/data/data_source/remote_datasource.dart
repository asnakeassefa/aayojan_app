import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_provider.dart';
import '../../../../core/network/endpoints.dart';
import '../../../profile/data/model/Profile_loaded.dart';
import '../../../profile/data/model/city_model.dart';
import '../../../profile/data/model/state_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> signIn(Map<String, String> data);
  Future<String> signUp(Map<String, dynamic> data);

  Future<String> verifyOTP(Map<String, String> data);
  Future<String> sendOTP(String phone);
  Future<String> resendOTP(String phone);
  Future<String> forgotPassword(String email);
  Future<String> resetPassword(String email, String password);

  Future<StateModel> getState();
  Future<CityModel> getCities(String stateId);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  ApiService api = ApiService();
  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Future<String> sendOTP(String phone) async {
    try {
      final response =
          await api.post(Endpoints.resendOTP, {"phoneNumber": phone});

      return response.data['data'];
    } catch (e) {
      log(e.toString());
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
  Future<String> signIn(Map<String, String> data) async {
    try {
      final response = await api.post(Endpoints.login, data);
      log(response.data.toString());
      return response.data['message'];
    } catch (e) {
      log(e.toString());
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
  Future<String> signUp(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(
        {
          'name': data['name'],
          'surname': data['surname'],
          'age': data['age'],
          'gender': data['gender'],
          'city': data['city'],
          'town': data['town'],
          'village': data['village'],
          'state': data['state'],
          'phone': data['phone'],
          'alternativePhone': data['alternativePhone'],
        },
      );

      String? image = data['profile'];
      // log(image.toString());
      if (image != null && image.isNotEmpty) {
        List<String> types = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];

        final extension = image.split('.').last.toLowerCase();
        if (!types.contains(extension)) {
          throw ClientException(message: 'Invalid image type');
        }
        formData.files.add(
          MapEntry(
            'profile',
            await MultipartFile.fromFile(
              image,
              filename: 'profile.$extension',
              contentType: MediaType('image', extension),
            ),
          ),
        );
      }
      final response = await api.upload(Endpoints.signUp, formData);
      return response.data['message'];
    } catch (e) {
      log(e.toString());
      if (e is ClientException) {
        rethrow;
      } else if (e is ServerException) {
        rethrow;
      } else {
        throw 'Something went wrong';
      }
    }
  }

  Future<ProfileModel> getProfile() async {
    try {
      final response = await api.get(Endpoints.userInfo);

      final res = ProfileModel.fromJson(response.data);

      FlutterSecureStorage storage = const FlutterSecureStorage();

      if (res.data?.user?.profile == null) {
        await storage.write(key: 'profilePic', value: '');
      } else {
        await storage.write(
            key: 'profilePic',
            value: '${Endpoints.imageUrl}${res.data?.user?.profile}');
      }

      if (res.data?.user?.familyId == null) {
        await storage.write(
            key: 'noFamilyId', value: '${res.data?.user?.familyId}');
      } else {
        await storage.delete(key: 'noFamilyId');
      }

      return res;
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
  Future<String> verifyOTP(Map<String, String> data) async {
    try {
      final response = await api.post(Endpoints.verify, data);
      log(response.toString());
      storage.write(key: 'accessToken', value: response.data['data']['token']);
      await getProfile();
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
  Future<String> forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<String> resetPassword(String email, String password) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<String> resendOTP(String phone) async {
    try {
      final response = await api.post(Endpoints.resendOTP, {"phone": phone});
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
  Future<CityModel> getCities(String stateId) async {
    try {
      final response = await api.get('${Endpoints.getCity}?state_id=$stateId');
      final res = CityModel.fromJson(response.data);
      return res;
    } catch (e) {
      log(e.toString());
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
  Future<StateModel> getState() async {
    try {
      final response = await api.get(Endpoints.getState);
      final res = StateModel.fromJson(response.data);
      return res;
    } catch (e) {
      log(e.toString());
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
