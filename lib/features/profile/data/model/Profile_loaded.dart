class ProfileModel {
  String? status;
  String? message;
  Data? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  User? user;

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerifiedAt;
  String? phone;
  String? otp;
  String? otpValidAt;
  String? gender;
  String? familyNickname;
  num? familyHead;
  num? familyId;
  num? deviceId;
  num? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  num? religionId;
  DropModel? religion;
  num? casteId;
  String? subCaste;
  num? age;
  DropModel? city;
  String? town;
  String? village;
  String? familyCount;
  String? kids;
  String? address;
  DropModel? state;
  String? alternatePhone;
  String? profile;
  num? memberAddedBy;
  num? relationId;
  num? relationCategoryId;
  String? deviceToken;
  String? samaj;
  num? communityId;
  DropModel? community;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.otp,
    this.otpValidAt,
    this.gender,
    this.familyNickname,
    this.familyHead,
    this.familyId,
    this.deviceId,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.religion,
    this.religionId,
    this.casteId,
    this.subCaste,
    this.age,
    this.city,
    this.town,
    this.village,
    this.familyCount,
    this.kids,
    this.address,
    this.state,
    this.alternatePhone,
    this.profile,
    this.memberAddedBy,
    this.relationId,
    this.relationCategoryId,
    this.deviceToken,
    this.samaj,
    this.communityId,
    this.community,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    otp = json['otp'];
    otpValidAt = json['otp_valid_at'];
    gender = json['gender'];
    familyNickname = json['family_nickname'];
    familyHead = json['family_head'];
    familyId = json['family_id'];
    deviceId = json['device_id'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    religionId = json['religion_id'];
    religion = json['religion'] != null
        ? new DropModel.fromJson(json['religion'])
        : null;
    casteId = json['caste_id'];
    subCaste = json['sub_caste'];
    age = json['age'];
    city = json['city'] != null ? new DropModel.fromJson(json['city']) : null;
    town = json['town'];
    familyCount = json['familyCount'];
    kids = json['kids'];
    address = json['address'];
    samaj = json['samaj'];
    communityId = json['community_id'];
    community = json['community'] != null
        ? new DropModel.fromJson(json['community'])
        : null;
    village = json['village'];
    state =
        json['state'] != null ? new DropModel.fromJson(json['state']) : null;
    alternatePhone = json['alternate_phone'];
    profile = json['profile'];
    memberAddedBy = json['member_added_by'];
    relationId = json['relation_id'];
    relationCategoryId = json['relation_category_id'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone'] = this.phone;
    data['otp'] = this.otp;
    data['otp_valid_at'] = this.otpValidAt;
    data['gender'] = this.gender;
    data['family_nickname'] = this.familyNickname;
    data['family_head'] = this.familyHead;
    data['family_id'] = this.familyId;
    data['device_id'] = this.deviceId;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['religion_id'] = this.religionId;
    data['caste_id'] = this.casteId;
    data['sub_caste'] = this.subCaste;
    data['age'] = this.age;
    data['city'] = this.city;
    data['town'] = this.town;
    data['village'] = this.village;
    data['state'] = this.state;
    data['alternate_phone'] = this.alternatePhone;
    data['profile'] = this.profile;
    data['member_added_by'] = this.memberAddedBy;
    data['relation_id'] = this.relationId;
    data['relation_category_id'] = this.relationCategoryId;
    data['device_token'] = this.deviceToken;
    return data;
  }
}

class DropModel {
  int? id;
  String? name;

  DropModel({this.id, this.name});

  DropModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
