import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_provider.dart';
import '../../../../core/network/endpoints.dart';
import '../model/Profile_loaded.dart';
import '../model/city_model.dart';
import '../model/community_model.dart';
import '../model/religion_model.dart';
import '../model/state_model.dart';

abstract class ProfileDataSource {
  Future<String> updateProfile(Map<String, dynamic> data);
  Future<ProfileModel> getProfile();
  Future<ReligionModel> getReligion();
  Future<CityModel> getCity(String stateId);
  Future<StateModel> getState();
  Future<CommunityModel> getCommunity(String religionId);
}

@Injectable(as: ProfileDataSource)
class ProfileDataSourceImpl implements ProfileDataSource {
  ApiService apiService = ApiService();

  ProfileDataSourceImpl();

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await apiService.get(Endpoints.userInfo);

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
  Future<String> updateProfile(Map<String, dynamic> data) async {
    try {
      // lets do this with document
      final formData = FormData.fromMap(
        {
          'profile': data['profile'],
          'name': data['name'],
          'surname': data['surname'],
          'age': data['age'],
          'gender': data['gender'],
          'city': data['city'],
          'state': data['state'],
          'town': data['town'],
          'family_nickname': data['family_nickname'],
          'is_exist_family_member': data['is_exist_family_member'],
          'family_id': data['family_id'],
          'religion_id': data['religion_id'],
          'community_id': data['community'],
          'address': data['address'],
          'kids': data['kids'],
          'phone': data['phone'],
          'alternate_phone': data['alt_phone'],
          'familyCount': data['familyCount'],
          'samaj': data['samaj'],
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
      final response =
          await apiService.upload(Endpoints.profileUpdate, formData);
      await getProfile();
      log('Profile updated successfully');
      return response.data['message'].toString();
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
  Future<ReligionModel> getReligion() async {
    try {
      final response = await apiService.get(Endpoints.getReligion);
      final res = ReligionModel.fromJson(response.data);
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
  Future<CityModel> getCity(String stateId) async {
    try {
      final response =
          await apiService.get('${Endpoints.getCity}?state_id=$stateId');
      final res = CityModel.fromJson(response.data);
      // log(res.toString());
      return res;
    } catch (e) {
      // log(e.toString());
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
  Future<CommunityModel> getCommunity(String religionId) async {
    try {
      final response =
          await apiService.get('${Endpoints.getCommunity}/$religionId');
      final res = CommunityModel.fromJson(response.data);
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
  Future<StateModel> getState() async {
    try {
      final response = await apiService.get(Endpoints.getState);
      final res = StateModel.fromJson(response.data);
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
}
