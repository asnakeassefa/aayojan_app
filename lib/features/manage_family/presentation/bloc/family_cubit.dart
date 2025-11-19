import 'dart:developer';

import 'package:aayojan/features/manage_family/domain/family_repository.dart';
import 'package:aayojan/features/manage_family/presentation/bloc/famil_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class FamilyCubit extends Cubit<FamilyState> {
  FamilyRepository repository;
  FamilyCubit(this.repository) : super(FamilyInitial());

  void getFamilies() async {
    try {
      emit(FamilyLoading());
      final response = await repository.getFamilies();
      final relations = await repository.getRelations();
      final relationCategories = await repository.getRelationCategories();
      emit(FamilyLoaded(response, relations, relationCategories));
    } catch (e) {
      emit(FamilyFailure(e.toString()));
    }
  }

  void addFamily(Map<String, dynamic> data) async {
    try {
      emit(FamilySaveLoading());
      final response = await repository.addFamily(data);
      emit(FamilySuccess(response));
    } catch (e) {
      emit(FamilyCreateFailure(e.toString()));
    }
  }

  void updateFamily(Map<String, dynamic> data, String id) async {
    try {
      emit(FamilySaveLoading());
      final response = await repository.updateFamily(data, id);
      emit(FamilySuccess(response));
    } catch (e) {
      emit(FamilyCreateFailure(e.toString()));
    }
  }

  void deleteFamily(String id) async {
    try {
      emit(FamilyLoading());
      final response = await repository.deleteFamily(id);
      emit(FamilySuccess(response));
      getFamilies();
    } catch (e) {
      emit(FamilyFailure(e.toString()));
    }
  }

  void getRelations() async {
    try {
      final response = await repository.getRelations();
      // final relationCategories = await repository.getRelationCategories();
      final states = await repository.getState();
      
      emit(RelationsLoaded(response, states));
    } catch (e) {
      log(e.toString());
      emit(FamilyFailure(e.toString()));
    }
  }

  void getCities(String stateId) async {
    try {
      emit(CityLoading());
      final response = await repository.getCities(stateId);
      emit(CityLoaded(response));
    } catch (e) {
      emit(FamilyFailure(e.toString()));
    }
  }
}
