class CommunityModel {
  String? status;
  String? message;
  List<Data>? data;

  CommunityModel({this.status, this.message, this.data});

  CommunityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  int? religionId;
  String? title;

  Data({this.id, this.religionId, this.title});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    religionId = json['religion_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['religion_id'] = this.religionId;
    data['title'] = this.title;
    return data;
  }
}
