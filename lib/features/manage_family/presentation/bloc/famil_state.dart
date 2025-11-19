import 'package:aayojan/features/manage_family/data/model/relation_model.dart';
import 'package:aayojan/features/profile/data/model/city_model.dart';
import 'package:aayojan/features/profile/data/model/state_model.dart';

import '../../data/model/family_model.dart';

sealed class FamilyState {}

class FamilyInitial extends FamilyState {}

class FamilyLoading extends FamilyState {}

class FamilySuccess extends FamilyState {
  final String message;
  FamilySuccess(this.message);
}

class FamilyFailure extends FamilyState {
  final String message;
  FamilyFailure(this.message);
}

class FamilyCreateFailure extends FamilyState {
  final String message;
  FamilyCreateFailure(this.message);
}

class RelationsLoaded extends FamilyState {
  final RelationModel relations;
  // final RelationModel relationCategories;
  final StateModel states;

  RelationsLoaded(this.relations, this.states);
}

class FamilySaveLoading extends FamilyState {}

class FamilyLoaded extends FamilyState {
  final RelationModel relations;
  final RelationModel relationCategories;
  final FamilyModel family;
  FamilyLoaded(this.family, this.relations, this.relationCategories);
}

class CityLoading extends FamilyState {}

class CityLoaded extends FamilyState {
  final CityModel cities;
  CityLoaded(this.cities);
}
