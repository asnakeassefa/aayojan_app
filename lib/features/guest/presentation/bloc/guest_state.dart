import 'package:aayojan/features/profile/data/model/city_model.dart';

import '../../../profile/data/model/community_model.dart';
import '../../../profile/data/model/religion_model.dart';
import '../../../profile/data/model/state_model.dart';
import '../../data/model/family_guest_model.dart';
import '../../data/model/guest_model.dart';
import '../../data/model/relation_model.dart';
import '../../data/model/single_guest_model.dart';
import '../../data/model/sub_event_guest_model.dart';

sealed class GuestState {}

class GuestInit extends GuestState {}

class GuestLoading extends GuestState {}

class GuestLoaded extends GuestState {
  final GuestModel guest;
  final GuestListModel? guestList;
  GuestLoaded(this.guest, this.guestList);
}

class GuestSuccess extends GuestState {
  final String message;
  GuestSuccess(this.message);
}

class GuestFailure extends GuestState {
  final String message;
  GuestFailure(this.message);
}

class GuestAddLoading extends GuestState {}

class RelationLoaded extends GuestState {
  // final RelationModel relation;
  final RelationModel catagory;
  final StateModel state;

  RelationLoaded(this.state, this.catagory);
}

class CityLoading extends GuestState {}

class CityLoaded extends GuestState {
  final CityModel city;
  CityLoaded(this.city);
}

class GuestSingleLoaded extends GuestState {
  final SGuestModel guest;
  GuestSingleLoaded(this.guest);
}

class EventGuestsLoaded extends GuestState {
  final GuestListModel guest;
  EventGuestsLoaded(this.guest);
}

// guest with phone
class GuestWithPhoneLoaded extends GuestState {
  final SGuestModel guest;
  GuestWithPhoneLoaded(this.guest);
}

class GuestWithPhoneLoading extends GuestState {}

class GuestWithPhoneFailure extends GuestState {
  final String message;
  GuestWithPhoneFailure(this.message);
}

class SingleGuestLoading extends GuestState {}


class FamilyMembersLoading extends GuestState {}

class FamilyMembersLoaded extends GuestState {
  final GuestFamilyModel familyModel;
  FamilyMembersLoaded(this.familyModel);
}

class FamilyMembersFailure extends GuestState {
  final String message;
  FamilyMembersFailure(this.message);
}