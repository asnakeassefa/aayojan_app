class SGuestModel {
  String? status;
  String? message;
  Data? data;

  SGuestModel({this.status, this.message, this.data});

  SGuestModel.fromJson(Map<String, dynamic> json) {
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
  Relation? relation;
  Relation? relationCategory;
  Religion? religion;
  Religion? community;

  Data(
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
      this.cityId,
      this.relation,
      this.relationCategory,
      this.religion,
      this.community});

  Data.fromJson(Map<String, dynamic> json) {
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
    relation = json['relation'] != null
        ? new Relation.fromJson(json['relation'])
        : null;
    relationCategory = json['relation_category'] != null
        ? new Relation.fromJson(json['relation_category'])
        : null;
    religion = json['religion'] != null
        ? new Religion.fromJson(json['religion'])
        : null;
    community = json['community'] != null
        ? new Religion.fromJson(json['community'])
        : null;
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
    if (this.relation != null) {
      data['relation'] = this.relation!.toJson();
    }
    if (this.relationCategory != null) {
      data['relation_category'] = this.relationCategory!.toJson();
    }
    if (this.religion != null) {
      data['religion'] = this.religion!.toJson();
    }
    if (this.community != null) {
      data['community'] = this.community!.toJson();
    }
    return data;
  }
}

class Relation {
  int? id;
  String? name;

  Relation({this.id, this.name});

  Relation.fromJson(Map<String, dynamic> json) {
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

class Religion {
  int? id;
  String? title;

  Religion({this.id, this.title});

  Religion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
