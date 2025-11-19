import 'package:aayojan/features/guest/data/model/family_guest_model.dart';
import 'package:aayojan/features/guest/data/model/sub_event_guest_model.dart';
import 'package:aayojan/features/profile/data/model/city_model.dart';
import 'package:aayojan/features/profile/data/model/community_model.dart';
import 'package:aayojan/features/profile/data/model/religion_model.dart';

import '../../profile/data/model/state_model.dart';
import '../data/model/guest_model.dart';
import '../data/model/relation_model.dart';
import '../data/model/single_guest_model.dart';

abstract class GuestRepository {
  Future<GuestModel> getGuests();
  Future<SGuestModel> getGuest(String id);
  Future<SGuestModel> getGuestByPhone(String phone);
  Future<GuestListModel> getEventGuests(id);
  Future<String> uploadExcelFile(Map<String, String> data);
  Future<RelationModel> getRelations();
  Future<StateModel> getState();
  Future<CityModel> getCity(String stateId);
  Future<RelationModel> getCategory();
  Future<String> addGuest(Map<String, dynamic> data);
  Future<String> editGuest(Map<String, dynamic> data, String id);
  Future<String> deleteGuest(String id);
  Future<String> addFamily(Map<String, dynamic> data);
  Future<String> getFamilies();
  Future<GuestModel> searchGuests(String query);
  Future<GuestFamilyModel> getFamilyMembers(String id);
}
