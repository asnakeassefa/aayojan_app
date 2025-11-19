import 'package:aayojan/features/manage_family/data/data_source/data_source.dart';
import 'package:aayojan/features/manage_family/data/model/family_model.dart';
import 'package:aayojan/features/profile/data/model/city_model.dart';
import 'package:aayojan/features/profile/data/model/state_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/family_repository.dart';
import '../model/relation_model.dart';

@Injectable(as: FamilyRepository)
class FamilyRepositoryImpl implements FamilyRepository {
  FamilyDataSource datasource;
  FamilyRepositoryImpl(this.datasource);
  @override
  Future<String> addFamily(Map<String, dynamic> data) async {
    try {
      return await datasource.addFamily(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FamilyModel> getFamilies() {
    try {
      return datasource.getFamilies();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateFamily(Map<String, dynamic> data, String id) {
    try {
      return datasource.updateFamily(data, id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RelationModel> getRelationCategories() async {
    try {
      return await datasource.getRelationCategories();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RelationModel> getRelations() async {
    try {
      return await datasource.getRelations();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteFamily(String id) async {
    try {
      return await datasource.deleteFamily(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CityModel> getCities(String stateId) async{
    try {
      return await datasource.getCities(stateId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<StateModel> getState() async{
    try {
      return await datasource.getState();
    } catch (e) {
      rethrow;
    }
  }
}
