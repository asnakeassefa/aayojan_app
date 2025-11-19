class SubEventModel {
  String? status;
  String? message;
  MainData? data;

  SubEventModel({this.status, this.message, this.data});

  SubEventModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new MainData.fromJson(json['data']) : null;
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

class MainData {
  num? currentPage;
  List<SubData>? data;
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

  MainData(
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

  MainData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <SubData>[];
      json['data'].forEach((v) {
        data!.add(new SubData.fromJson(v));
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

class SubData {
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
  num? acceptWithThanksCount;
  num? notSureToAttendCount;
  num? unableToAttendCount;
  num? invitedGuestCount;
  String? totalAttendees;
  Event? event;

  SubData(
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
      this.updatedAt,
      this.acceptWithThanksCount,
      this.notSureToAttendCount,
      this.unableToAttendCount,
      this.invitedGuestCount,
      this.totalAttendees,
      this.event});

  SubData.fromJson(Map<String, dynamic> json) {
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
    acceptWithThanksCount = json['accept_with_thanks_count'];
    notSureToAttendCount = json['not_sure_to_attend_count'];
    unableToAttendCount = json['unable_to_attend_count'];
    invitedGuestCount = json['invited_guest_count'];
    totalAttendees = json['total_attendees'].toString();
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
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
    data['accept_with_thanks_count'] = this.acceptWithThanksCount;
    data['not_sure_to_attend_count'] = this.notSureToAttendCount;
    data['unable_to_attend_count'] = this.unableToAttendCount;
    data['invited_guest_count'] = this.invitedGuestCount;
    data['total_attendees'] = this.totalAttendees;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    return data;
  }
}

class Event {
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
  User? user;

  Event(
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
      this.updatedAt,
      this.user});

  Event.fromJson(Map<String, dynamic> json) {
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
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
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
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  num? id;
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
  num? casteId;
  String? subCaste;
  num? age;
  String? city;
  String? town;
  String? village;
  String? state;
  String? alternatePhone;
  String? profile;
  num? memberAddedBy;
  num? relationId;
  num? relationCategoryId;
  String? deviceToken;

  User(
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
      this.city,
      this.town,
      this.village,
      this.state,
      this.alternatePhone,
      this.profile,
      this.memberAddedBy,
      this.relationId,
      this.relationCategoryId,
      this.deviceToken});

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
    casteId = json['caste_id'];
    subCaste = json['sub_caste'];
    age = json['age'];
    city = json['city'];
    town = json['town'];
    village = json['village'];
    state = json['state'];
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
