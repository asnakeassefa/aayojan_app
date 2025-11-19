class InvitationModel {
  String? status;
  String? message;
  GenData? data;

  InvitationModel({this.status, this.message, this.data});

  InvitationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new GenData.fromJson(json['data']) : null;
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

class GenData {
  num? currentPage;
  List<EventData>? data;
  String? firstPageUrl;
  num? from;
  num? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  num? perPage;
  String? prevPageUrl;
  num? to;
  num? total;

  GenData(
      {this.currentPage,
      this.data,
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

  GenData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <EventData>[];
      json['data'].forEach((v) {
        data!.add(new EventData.fromJson(v));
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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

class EventData {
  num? id;
  num? guestId;
  num? mainEventId;
  num? subEventId;
  num? status;
  num? attendMemberCount;
  String? guestResponsePreferences;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  MainEvent? mainEvent;
  SubEvent? subEvent;

  EventData(
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
      this.mainEvent,
      this.subEvent});

  EventData.fromJson(Map<String, dynamic> json) {
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
    mainEvent = json['main_event'] != null
        ? new MainEvent.fromJson(json['main_event'])
        : null;
    subEvent = json['sub_event'] != null
        ? new SubEvent.fromJson(json['sub_event'])
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
    if (this.mainEvent != null) {
      data['main_event'] = this.mainEvent!.toJson();
    }
    if (this.subEvent != null) {
      data['sub_event'] = this.subEvent!.toJson();
    }
    return data;
  }
}

class MainEvent {
  num? id;
  num? userId;
  String? title;
  String? description;
  String? venue;
  String? startDate;
  String? endDate;
  String? time;
  num? status;
  String? eventType;
  String? document;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  MainEvent(
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

  MainEvent.fromJson(Map<String, dynamic> json) {
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

class SubEvent {
  num? id;
  num? mainEventId;
  String? title;
  String? venue;
  String? startDate;
  String? endDate;
  num? status;
  String? time;
  String? timesOfDay;
  String? guestResponsePreferences;
  String? document;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  SubEvent(
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

  SubEvent.fromJson(Map<String, dynamic> json) {
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
