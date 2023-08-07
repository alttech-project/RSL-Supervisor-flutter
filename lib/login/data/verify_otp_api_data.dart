import 'dart:convert';

class VerifyOtpRequest {
  String? username;
  String? otp;
  double? latitude;
  double? longitude;
  String? deviceToken;

  VerifyOtpRequest(
      {this.username,
      this.otp,
      this.latitude,
      this.longitude,
      this.deviceToken});

  VerifyOtpRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    otp = json['otp'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['otp'] = otp;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['device_token'] = deviceToken;
    return data;
  }
}

class VerifyOtpResponse {
  String? message;
  int? status;
  Detail? detail;
  String? authKey;

  VerifyOtpResponse({this.message, this.status, this.detail, this.authKey});

  VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    detail = json['detail'] != null ? Detail.fromJson(json['detail']) : null;
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.detail != null) {
      data['detail'] = detail!.toJson();
    }
    data['auth_key'] = authKey;
    return data;
  }
}

class Detail {
  String? email;
  int? supervisorId;
  String? address;
  String? name;
  String? uniqueId;
  String? phone;
  int? companyId;
  List<KioskList>? kioskList;

  Detail(
      {this.email,
      this.supervisorId,
      this.address,
      this.name,
      this.uniqueId,
      this.phone,
      this.companyId,
      this.kioskList});

  Detail.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    supervisorId = json['supervisor_id'];
    address = json['address'];
    name = json['name'];
    uniqueId = json['unique_id'];
    phone = json['phone'];
    companyId = json['company_id'];
    if (json['kiosk_list'] != null) {
      kioskList = <KioskList>[];
      json['kiosk_list'].forEach((v) {
        kioskList!.add(new KioskList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['supervisor_id'] = supervisorId;
    data['address'] = address;
    data['name'] = name;
    data['unique_id'] = uniqueId;
    data['phone'] = phone;
    data['company_id'] = companyId;
    if (this.kioskList != null) {
      data['kiosk_list'] = kioskList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KioskList {
  int? kioskId;
  String? kioskName;
  String? address;
  String? phone;
  List<PolygonPoints>? polygonPoints;

  KioskList(
      {this.kioskId,
      this.kioskName,
      this.address,
      this.phone,
      this.polygonPoints});

  KioskList.fromJson(Map<String, dynamic> json) {
    kioskId = json['kiosk_id'];
    kioskName = json['kiosk_name'];
    address = json['address'];
    phone = json['phone'];
    if (json['polygon_points'] != null) {
      polygonPoints = <PolygonPoints>[];
      json['polygon_points'].forEach((v) {
        polygonPoints!.add(PolygonPoints.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kiosk_id'] = kioskId;
    data['kiosk_name'] = kioskName;
    data['address'] = address;
    data['phone'] = phone;
    if (polygonPoints != null) {
      data['polygon_points'] = polygonPoints!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PolygonPoints {
  double? lat;
  double? lng;

  PolygonPoints({this.lat, this.lng});

  PolygonPoints.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

VerifyOtpResponse verifyOtpResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return VerifyOtpResponse.fromJson(jsonData);
}

String verifyOtpRequestToJson(VerifyOtpRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
