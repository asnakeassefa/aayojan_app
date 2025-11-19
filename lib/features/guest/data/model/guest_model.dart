class GuestModel {
  String? status;
  String? message;
  DynamicData? data; // Changed Data to DynamicData

  GuestModel({this.status, this.message, this.data});

  GuestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DynamicData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DynamicData {
  Map<String, List<Guest>>? guestCategories;

  DynamicData({this.guestCategories});

  DynamicData.fromJson(Map<String, dynamic> json) {
    guestCategories = {};
    json.forEach((key, value) {
      if (value is List) {
        guestCategories![key] = value.map((v) => Guest.fromJson(v)).toList();
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    guestCategories?.forEach((key, value) {
      data[key] = value.map((v) => v.toJson()).toList();
    });
    return data;
  }
}

class Guest {
  int? id;
  String? fullName;
  int? age;
  int? relationId;
  int? relationCategoryId;
  int? casteId;
  int? userId;
  String? phoneNumber;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  RelationCategory? relationCategory;

  Guest({
    this.id,
    this.fullName,
    this.age,
    this.relationId,
    this.relationCategoryId,
    this.casteId,
    this.userId,
    this.phoneNumber,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.relationCategory,
  });

  Guest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    age = json['age'];
    relationId = json['relation_id'];
    relationCategoryId = json['relation_category_id'];
    casteId = json['caste_id'];
    userId = json['user_id'];
    phoneNumber = json['phone_number'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    relationCategory = json['relation_category'] != null
        ? RelationCategory.fromJson(json['relation_category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['age'] = age;
    data['relation_id'] = relationId;
    data['relation_category_id'] = relationCategoryId;
    data['caste_id'] = casteId;
    data['user_id'] = userId;
    data['phone_number'] = phoneNumber;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (relationCategory != null) {
      data['relation_category'] = relationCategory!.toJson();
    }
    return data;
  }
}

class RelationCategory {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  RelationCategory({this.id, this.name, this.createdAt, this.updatedAt});

  RelationCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}