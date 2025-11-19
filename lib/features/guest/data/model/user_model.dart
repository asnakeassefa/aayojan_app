class UserModel {
  String? status;
  String? message;
  List<UserData>? data;

  UserModel({this.status, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(new UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  bool? emailVerifiedAt;
  String? phone;
  String? alternatePhone;
  String? otp;
  String? otpValidAt;
  String? gender;
  int? age;
  String? familyNickname;
  int? familyHead;
  String? familyCount;
  String? kids;
  int? familyId;
  String? address;
  String? town;
  String? samaj;
  String? profile;
  String? deviceToken;
  int? religionId;
  int? stateId;
  int? cityId;
  int? memberAddedBy;
  int? relationId;
  int? relationCategoryId;
  int? communityId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  UserData(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.emailVerifiedAt,
      this.phone,
      this.alternatePhone,
      this.otp,
      this.otpValidAt,
      this.gender,
      this.age,
      this.familyNickname,
      this.familyHead,
      this.familyCount,
      this.kids,
      this.familyId,
      this.address,
      this.town,
      this.samaj,
      this.profile,
      this.deviceToken,
      this.religionId,
      this.stateId,
      this.cityId,
      this.memberAddedBy,
      this.relationId,
      this.relationCategoryId,
      this.communityId,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    alternatePhone = json['alternate_phone'];
    otp = json['otp'];
    otpValidAt = json['otp_valid_at'];
    gender = json['gender'];
    age = json['age'];
    familyNickname = json['family_nickname'];
    familyHead = json['family_head'];
    familyCount = json['familyCount'];
    kids = json['kids'];
    familyId = json['family_id'];
    address = json['address'];
    town = json['town'];
    samaj = json['samaj'];
    profile = json['profile'];
    deviceToken = json['device_token'];
    religionId = json['religion_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    memberAddedBy = json['member_added_by'];
    relationId = json['relation_id'];
    relationCategoryId = json['relation_category_id'];
    communityId = json['community_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone'] = this.phone;
    data['alternate_phone'] = this.alternatePhone;
    data['otp'] = this.otp;
    data['otp_valid_at'] = this.otpValidAt;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['family_nickname'] = this.familyNickname;
    data['family_head'] = this.familyHead;
    data['familyCount'] = this.familyCount;
    data['kids'] = this.kids;
    data['family_id'] = this.familyId;
    data['address'] = this.address;
    data['town'] = this.town;
    data['samaj'] = this.samaj;
    data['profile'] = this.profile;
    data['device_token'] = this.deviceToken;
    data['religion_id'] = this.religionId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['member_added_by'] = this.memberAddedBy;
    data['relation_id'] = this.relationId;
    data['relation_category_id'] = this.relationCategoryId;
    data['community_id'] = this.communityId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
