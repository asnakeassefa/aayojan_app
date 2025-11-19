import 'package:aayojan/features/guest/data/model/family_guest_model.dart';
import 'package:aayojan/features/guest/data/model/single_guest_model.dart';
import 'package:aayojan/features/guest/data/model/sub_event_guest_model.dart';
import 'package:aayojan/features/profile/data/model/city_model.dart';
import 'package:aayojan/features/profile/data/model/community_model.dart';
import 'package:aayojan/features/profile/data/model/religion_model.dart';
import 'package:injectable/injectable.dart';

import '../../../profile/data/model/state_model.dart';
import '../../domain/guest_repository.dart';
import '../datasource/guest_data_source.dart';
import '../model/guest_model.dart';
import '../model/relation_model.dart';

@Injectable(as: GuestRepository)
class GuestRepositoryImpl implements GuestRepository {
  final GuestDataSource dataSource;
  GuestRepositoryImpl(this.dataSource);
  @override
  Future<String> addFamily(Map<String, dynamic> data) {
    // TODO: implement addFamily
    throw UnimplementedError();
  }

  @override
  Future<String> addGuest(Map<String, dynamic> data) async {
    try {
      return await dataSource.addGuest(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getFamilies() {
    // TODO: implement getFamilies
    throw UnimplementedError();
  }

  @override
  Future<GuestModel> getGuests() async {
    try {
      return await dataSource.getGuests("");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> uploadExcelFile(Map<String, String> data) async {
    try {
      return await dataSource.uploadExcelFile(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RelationModel> getRelations() async {
    try {
      return await dataSource.getRelations();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GuestModel> searchGuests(String query) async {
    try {
      return await dataSource.getGuests(query);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CityModel> getCity(String stateId) async {
    try {
      return await dataSource.getCity(stateId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<StateModel> getState() async {
    try {
      return await dataSource.getState();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RelationModel> getCategory() async {
    try {
      return await dataSource.getCategory();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> editGuest(Map<String, dynamic> data, String id) async {
    try {
      return await dataSource.editGuest(data, id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteGuest(String id) async {
    try {
      return await dataSource.deleteGuest(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SGuestModel> getGuest(String id) async {
    try {
      return await dataSource.getGuest(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GuestListModel> getEventGuests(id) async {
    try {
      return await dataSource.getEventGuests(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SGuestModel> getGuestByPhone(String phone) async {
    try {
      return await dataSource.getGuestByPhone(phone);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GuestFamilyModel> getFamilyMembers(String id) async{
    try {
      return await dataSource.getFamilyMembers(id);
    } catch (e) {
      rethrow;
    }
  }
}
