class FamilyModel {
  String? status;
  String? message;
  List<FamilyData>? familyData;

  FamilyModel({this.status, this.message, this.familyData});

  FamilyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      familyData = <FamilyData>[];
      json['data'].forEach((v) {
        familyData!.add(new FamilyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.familyData != null) {
      data['data'] = this.familyData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FamilyData {
  Members? members;
  int? count;

  FamilyData({this.members, this.count});

  FamilyData.fromJson(Map<String, dynamic> json) {
    members =
        json['members'] != null ? new Members.fromJson(json['members']) : null;
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.members != null) {
      data['members'] = this.members!.toJson();
    }
    data['count'] = this.count;
    return data;
  }
}

class Members {
  int? currentPage;
  List<MemberData>? memberData;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Members(
      {this.currentPage,
      this.memberData,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Members.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      memberData = <MemberData>[];
      json['data'].forEach((v) {
        memberData!.add(new MemberData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.memberData != null) {
      data['data'] = this.memberData!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class MemberData {
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
  int? familyHead;
  int? familyId;
  String? deviceId;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? religionId;
  int? casteId;
  String? subCaste;
  int? age;
  int? cityId;
  String? town;
  String? village;
  String? familyCount;
  String? address;
  String? kids;
  int? stateId;
  String? alternatePhone;
  String? profile;
  int? memberAddedBy;
  int? relationId;
  int? relationCategoryId;
  String? deviceToken;

  MemberData(
      {this.id,
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
      this.religionId,
      this.casteId,
      this.subCaste,
      this.age,
      this.cityId,
      this.town,
      this.village,
      this.familyCount,
      this.address,
      this.kids,
      this.stateId,
      this.alternatePhone,
      this.profile,
      this.memberAddedBy,
      this.relationId,
      this.relationCategoryId,
      this.deviceToken});

  MemberData.fromJson(Map<String, dynamic> json) {
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
    casteId = json['caste_id'];
    subCaste = json['sub_caste'];
    age = json['age'];
    cityId = json['city_id'];
    town = json['town'];
    village = json['village'];
    familyCount = json['familyCount'];
    kids = json['kids'];
    address = json['address'];
    stateId = json['state_id'];
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
    data['city_id'] = this.cityId;
    data['town'] = this.town;
    data['village'] = this.village;
    data['familyCount'] = this.familyCount;
    data['kids'] = this.kids;
    data['address'] = this.address;
    data['state_id'] = this.stateId;
    data['alternate_phone'] = this.alternatePhone;
    data['profile'] = this.profile;
    data['member_added_by'] = this.memberAddedBy;
    data['relation_id'] = this.relationId;
    data['relation_category_id'] = this.relationCategoryId;
    data['device_token'] = this.deviceToken;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
