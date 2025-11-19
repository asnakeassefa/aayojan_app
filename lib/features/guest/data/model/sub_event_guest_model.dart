class GuestListModel {
  String? status;
  String? message;
  List<EventData>? data;

  GuestListModel({this.status, this.message, this.data});

  GuestListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EventData>[];
      json['data'].forEach((v) {
        data!.add(new EventData.fromJson(v));
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

class EventData {
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
  Pivot? pivot;

  EventData(
      {this.id,
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
      this.pivot});

  EventData.fromJson(Map<String, dynamic> json) {
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
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
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
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? mainEventId;
  int? guestId;
  String? createdAt;
  String? updatedAt;

  Pivot({this.mainEventId, this.guestId, this.createdAt, this.updatedAt});

  Pivot.fromJson(Map<String, dynamic> json) {
    mainEventId = json['main_event_id'];
    guestId = json['guest_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_event_id'] = this.mainEventId;
    data['guest_id'] = this.guestId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
