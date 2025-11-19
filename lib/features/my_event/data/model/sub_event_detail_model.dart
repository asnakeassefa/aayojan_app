class SubEventDetailModel {
  String? status;
  String? message;
  Data? data;

  SubEventDetailModel({this.status, this.message, this.data});

  SubEventDetailModel.fromJson(Map<String, dynamic> json) {
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
  int? mainEventId;
  String? title;
  String? venue;
  String? startDate;
  String? endDate;
  int? status;
  String? time;
  String? timesOfDay;
  String? guestResponsePreferences;
  String? document;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.mainEventId,
      this.title,
      this.venue,
      this.startDate,
      this.endDate,
      this.status,
      this.time,
      this.timesOfDay,
      this.guestResponsePreferences,
      this.document,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainEventId = json['main_event_id'];
    title = json['title'];
    venue = json['venue'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    time = json['time'];
    timesOfDay = json['times_of_day'];
    guestResponsePreferences = json['guest_response_preferences'];
    document = json['document'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main_event_id'] = this.mainEventId;
    data['title'] = this.title;
    data['venue'] = this.venue;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    data['time'] = this.time;
    data['times_of_day'] = this.timesOfDay;
    data['guest_response_preferences'] = this.guestResponsePreferences;
    data['document'] = this.document;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
