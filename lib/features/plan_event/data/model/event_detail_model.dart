class EventDetailModel {
  String? status;
  String? message;
  Data? data;

  EventDetailModel({this.status, this.message, this.data});

  EventDetailModel.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? title;
  String? description;
  String? venue;
  String? startDate;
  String? endDate;
  String? time;
  int? status;
  String? eventType;
  String? document;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.userId,
      this.title,
      this.description,
      this.venue,
      this.startDate,
      this.endDate,
      this.time,
      this.status,
      this.eventType,
      this.document,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    venue = json['venue'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    time = json['time'];
    status = json['status'];
    eventType = json['event_type'];
    document = json['document'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['venue'] = this.venue;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['time'] = this.time;
    data['status'] = this.status;
    data['event_type'] = this.eventType;
    data['document'] = this.document;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
