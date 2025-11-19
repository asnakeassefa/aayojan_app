
import 'package:aayojan/features/manage_family/data/model/family_model.dart';
import 'package:aayojan/features/profile/data/model/city_model.dart';
import 'package:aayojan/features/profile/data/model/state_model.dart';

import '../data/model/relation_model.dart';


abstract class FamilyRepository {
  Future<FamilyModel> getFamilies();
  Future<String> addFamily(Map<String, dynamic> data);
  Future<String> updateFamily(Map<String, dynamic> data, String id);
  Future<RelationModel> getRelations();
  Future<RelationModel> getRelationCategories();
  Future<String> deleteFamily(String id);

  Future<StateModel> getState();
  Future<CityModel> getCities(String stateId);
}