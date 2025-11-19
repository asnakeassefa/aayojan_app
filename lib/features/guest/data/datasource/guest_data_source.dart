import 'dart:developer';

import 'package:aayojan/core/network/api_provider.dart';
import 'package:aayojan/features/guest/data/model/user_model.dart';
import 'package:aayojan/features/profile/data/model/community_model.dart';
import 'package:aayojan/features/profile/data/model/religion_model.dart';
import 'package:aayojan/features/profile/data/model/state_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/endpoints.dart';
import '../../../profile/data/model/city_model.dart';
import '../model/family_guest_model.dart';
import '../model/guest_model.dart';
import '../model/relation_model.dart';
import '../model/single_guest_model.dart';
import '../model/sub_event_guest_model.dart';

abstract class GuestDataSource {
  Future<GuestModel> getGuests(String? query);
  Future<SGuestModel> getGuest(String? id);
  Future<SGuestModel> getGuestByPhone(String phone);
  Future<GuestListModel> getEventGuests(String id);
  Future<RelationModel> getRelations();
  Future<StateModel> getState();
  Future<CityModel> getCity(String stateId);
  Future<RelationModel> getCategory();
  Future<String> uploadExcelFile(Map<String, dynamic> data);
  Future<String> addGuest(Map<String, dynamic> data);
  Future<String> editGuest(Map<String, dynamic> data, String id);
  Future<String> deleteGuest(String id);
  Future<String> addFamily(Map<String, dynamic> data);
  Future<String> getFamilies();
  Future<GuestFamilyModel> getFamilyMembers(String id);
}

@Injectable(as: GuestDataSource)
class GuestDataSourceImpl implements GuestDataSource {
  ApiService apiService = ApiService();
  @override
  Future<String> addFamily(Map<String, dynamic> data) {
    // TODO: implement addFamily
    throw UnimplementedError();
  }

  @override
  Future<String> addGuest(Map<String, dynamic> data) async {
    try {
      final response = await apiService.post(Endpoints.addGuest, data);
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
  Future<String> getFamilies() {
    // TODO: implement getFamilies
    throw UnimplementedError();
  }

  @override
  Future<GuestModel> getGuests(String? query) async {
    try {
      final response =
          await apiService.get("${Endpoints.getGuests}?search=$query&per_page");
      return GuestModel.fromJson(response.data);
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
  Future<String> uploadExcelFile(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap({});

      String? image = data['file'];
      if (image != null) {
        final extension = image..split('.').last.toLowerCase();

        formData.files.add(MapEntry(
          'file',
          await MultipartFile.fromFile(
            image,
            filename: 'guestlist.$extension',
            contentType: MediaType('csv', extension),
          ),
        ));
      }
      final response =
          await apiService.upload(Endpoints.uploadExcelFile, formData);
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
  Future<CityModel> getCity(String stateId) async {
    try {
      final response = await apiService.get('${Endpoints.getCity}?state_id=$stateId');
      final res = CityModel.fromJson(response.data);
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
  Future<RelationModel> getCategory() async {
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
  Future<String> deleteGuest(String id) async {
    try {
      final response = await apiService.delete('${Endpoints.deleteGuest}/$id');
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
  Future<String> editGuest(Map<String, dynamic> data, String id) async {
    try {
      final response = await apiService.put('${Endpoints.editGuest}/$id', data);
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
  Future<SGuestModel> getGuest(String? id) async {
    try {
      final response = await apiService.get('${Endpoints.getGuests}/$id');
      return SGuestModel.fromJson(response.data);
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
  Future<GuestListModel> getEventGuests(String id) async {
    try {
      final response = await apiService.get('${Endpoints.getEventGuests}/$id');
      return GuestListModel.fromJson(response.data);
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
  Future<SGuestModel> getGuestByPhone(String phone) async {
    try {
      final response =
          await apiService.get('${Endpoints.getGuestByPhone}/$phone');
      return SGuestModel.fromJson(response.data);
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

  Future<UserModel> fetchUserByPhone(String phone) async {
    try {
      final response =
          await apiService.get('${Endpoints.getUserByPhone}?phone=$phone');
      return UserModel.fromJson(response.data);
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
  Future<GuestFamilyModel> getFamilyMembers(String id) async{
    try {
      final response = await apiService.get('${Endpoints.getFamilyMembers}/$id');
      log(response.data.toString());
      return GuestFamilyModel.fromJson(response.data);
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
