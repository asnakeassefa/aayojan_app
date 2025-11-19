class SubEventGuestModel {
  String? status;
  String? message;
  Data? data;

  SubEventGuestModel({this.status, this.message, this.data});

  SubEventGuestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<GuestList>? invitedGuestList;
  List<SubEventGuestList>? nonInviteGuestList;

  Data({this.invitedGuestList, this.nonInviteGuestList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['invitedGuestList'] != null) {
      invitedGuestList = <GuestList>[];
      json['invitedGuestList'].forEach((v) {
        invitedGuestList!.add(new GuestList.fromJson(v));
      });
    }
    if (json['nonInviteGuestList'] != null) {
      nonInviteGuestList = <SubEventGuestList>[];
      json['nonInviteGuestList'].forEach((v) {
        nonInviteGuestList!.add(new SubEventGuestList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.invitedGuestList != null) {
      data['invitedGuestList'] =
          this.invitedGuestList!.map((v) => v.toJson()).toList();
    }
    if (this.nonInviteGuestList != null) {
      data['nonInviteGuestList'] =
          this.nonInviteGuestList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GuestList {
  int? id;
  int? guestId;
  int? mainEventId;
  int? subEventId;
  int? status;
  int? attendMemberCount;
  String? guestResponsePreferences;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  SubEventGuestList? subEventGuestList;

  GuestList(
      {this.id,
      this.guestId,
      this.mainEventId,
      this.subEventId,
      this.status,
      this.attendMemberCount,
      this.guestResponsePreferences,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.subEventGuestList});

  GuestList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    guestId = json['guest_id'];
    mainEventId = json['main_event_id'];
    subEventId = json['sub_event_id'];
    status = json['status'];
    attendMemberCount = json['attend_member_count'];
    guestResponsePreferences = json['guest_response_preferences'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subEventGuestList = json['sub_event_guest_list'] != null
        ? new SubEventGuestList.fromJson(json['sub_event_guest_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['guest_id'] = this.guestId;
    data['main_event_id'] = this.mainEventId;
    data['sub_event_id'] = this.subEventId;
    data['status'] = this.status;
    data['attend_member_count'] = this.attendMemberCount;
    data['guest_response_preferences'] = this.guestResponsePreferences;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.subEventGuestList != null) {
      data['sub_event_guest_list'] = this.subEventGuestList!.toJson();
    }
    return data;
  }
}

class SubEventGuestList {
  int? id;
  String? fullName;
  int? age;
  int? relationId;
  int? relationCategoryId;
  int? casteId;
  int? userId;
  String? phoneNumber;
  String? alternatePhoneNumber;
  int? religionId;
  int? communityId;
  String? samaj;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? stateId;
  int? cityId;

  SubEventGuestList(
      {this.id,
      this.fullName,
      this.age,
      this.relationId,
      this.relationCategoryId,
      this.casteId,
      this.userId,
      this.phoneNumber,
      this.alternatePhoneNumber,
      this.religionId,
      this.communityId,
      this.samaj,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.stateId,
      this.cityId});

  SubEventGuestList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    age = json['age'];
    relationId = json['relation_id'];
    relationCategoryId = json['relation_category_id'];
    casteId = json['caste_id'];
    userId = json['user_id'];
    phoneNumber = json['phone_number'];
    alternatePhoneNumber = json['alternate_phone_number'];
    religionId = json['religion_id'];
    communityId = json['community_id'];
    samaj = json['samaj'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    stateId = json['state_id'];
    cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['age'] = this.age;
    data['relation_id'] = this.relationId;
    data['relation_category_id'] = this.relationCategoryId;
    data['caste_id'] = this.casteId;
    data['user_id'] = this.userId;
    data['phone_number'] = this.phoneNumber;
    data['alternate_phone_number'] = this.alternatePhoneNumber;
    data['religion_id'] = this.religionId;
    data['community_id'] = this.communityId;
    data['samaj'] = this.samaj;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    return data;
  }
}
