import 'dart:developer';

import 'package:aayojan/features/manage_family/data/model/family_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_provider.dart';
import '../../../../core/network/endpoints.dart';
import '../../../profile/data/model/city_model.dart';
import '../../../profile/data/model/state_model.dart';
import '../model/relation_model.dart';

abstract class FamilyDataSource {
  Future<FamilyModel> getFamilies();
  Future<String> addFamily(Map<String, dynamic> data);
  Future<String> updateFamily(Map<String, dynamic> data, String id);
  Future<RelationModel> getRelations();
  Future<RelationModel> getRelationCategories();
  Future<String> deleteFamily(String id);

  Future<StateModel> getState();
  Future<CityModel> getCities(String stateId);
}

@Injectable(as: FamilyDataSource)
class FamilyDataSourceImpl implements FamilyDataSource {
  ApiService apiService = ApiService();

  FamilyDataSourceImpl();

  @override
  Future<FamilyModel> getFamilies() async {
    try {
      final response = await apiService.get(Endpoints.getFamilies);
      final res = FamilyModel.fromJson(response.data);
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
  Future<String> addFamily(Map<String, dynamic> data) async {
    log('here');
    try {
      final formData = FormData.fromMap(
        {
          "relation_id": data['relation'],
          'first_name': data['first_name'],
          'last_name': data['last_name'],
          'age': data['age'],
          'gender': data['gender'],
          'state': data['state'],
          'city': data['city'],
          'address': data['address'],
          'phone': data['phone'],
          'alternate_phone': data['alt_phone'],
          'town': data['town'],
          'email': data['email'],
          // "relation_category_id": data['category'],
        },
      );
      log('after adding data');

      String? image = data['profile'];
      if (image == null) {
        throw ClientException(message: 'Image is required');
      }

      List<String> types = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
      if (image.isNotEmpty) {
        final extension = image.split('.').last.toLowerCase();
        if (!types.contains(extension)) {
          throw Exception('Invalid image type');
        }
        formData.files.add(MapEntry(
          'profile',
          await MultipartFile.fromFile(
            image,
            filename: 'profile.$extension',
            contentType: MediaType('image', extension),
          ),
        ));
      }
      final response =
          await apiService.upload(Endpoints.createFamily, formData);
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
  Future<String> updateFamily(Map<String, dynamic> data, String id) async {
    try {
      log(id.toString());
      final formData = FormData.fromMap(
        {
          "relation_id": data['relation'],
          'first_name': data['first_name'],
          'last_name': data['last_name'],
          'age': data['age'],
          'gender': data['gender'],
          'state': data['state'],
          'city': data['city'],
          'address': data['address'],
          'phone': data['phone'],
          'alternate_phone': data['alt_phone'],
          'town': data['town'],
          'email': data['email'],
          // "relation_category_id": data['category'],
        },
      );
      log('after adding data');

      String? image = data['profile'];
      List<String> types = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
      if (image != null) {
        final extension = image.split('.').last.toLowerCase();
        if (!types.contains(extension)) {
          throw ClientException(message: 'Invalid image type');
        }
        formData.files.add(MapEntry(
          'profile',
          await MultipartFile.fromFile(
            image,
            filename: 'profile.$extension',
            contentType: MediaType('image', extension),
          ),
        ));
      }
      final response =
          await apiService.upload("${Endpoints.updateFamily}/$id", formData);
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
  Future<RelationModel> getRelationCategories() async {
    try {
      final response = await apiService.get(Endpoints.getRelationCategories);
      final res = RelationModel.fromJson(response.data);
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
  Future<RelationModel> getRelations() async {
    try {
      final response = await apiService.get(Endpoints.getRelations);
      final res = RelationModel.fromJson(response.data);
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
  Future<String> deleteFamily(String id) async {
    try {
      final response = await apiService.delete("${Endpoints.deleteFamily}/$id");
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
  Future<CityModel> getCities(String stateId) async {
    try {
      final response =
          await apiService.get('${Endpoints.getCity}?state_id=$stateId');
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
      final response = await apiService.get(Endpoints.getState);
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
