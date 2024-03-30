import 'dart:convert';

class VerifySuperVisorLocationRequestData {
  String? supervisorId;
  String? cid;
  double? latitude;
  double? longitude;
  double? accuracy;
  String? photoUrl;

  VerifySuperVisorLocationRequestData(
      {this.supervisorId,
      this.cid,
      this.latitude,
      this.longitude,
      this.accuracy,
      this.photoUrl});

  VerifySuperVisorLocationRequestData.fromJson(Map<String, dynamic> json) {
    supervisorId = json['supervisor_id'];
    cid = json['cid'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    accuracy = json['accuracy'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supervisor_id'] = supervisorId;
    data['cid'] = cid;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['accuracy'] = accuracy;
    data['photo_url'] = photoUrl;
    return data;
  }
}

class VerifySuperVisorLocationResponseData {
  String? message;
  int? status;
  String? authKey;

  VerifySuperVisorLocationResponseData(
      {this.message, this.status, this.authKey});

  VerifySuperVisorLocationResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['auth_key'] = authKey;
    return data;
  }
}

VerifySuperVisorLocationResponseData verifyLogoutApiResponseFromJson(
    String str) {
  final jsonData = json.decode(str);
  return VerifySuperVisorLocationResponseData.fromJson(jsonData);
}

String verifyLogoutApiRequestToJson(VerifySuperVisorLocationRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
