import 'dart:convert';

class DasboardApiRequest {
  String? kioskId;
  String? supervisorId;
  String? cid;
  String? deviceToken;

  DasboardApiRequest(
      {this.kioskId, this.supervisorId, this.cid, this.deviceToken});

  DasboardApiRequest.fromJson(Map<String, dynamic> json) {
    kioskId = json['kiosk_id'];
    supervisorId = json['supervisor_id'];
    cid = json['cid'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kiosk_id'] = kioskId;
    data['supervisor_id'] = supervisorId;
    data['cid'] = cid;
    data['device_token'] = deviceToken;
    return data;
  }
}

class DasboardApiResponse {
  int? httpCode;
  int? status;
  String? message;
  List<DropOffList>? dropOffList;

  DasboardApiResponse(
      {this.httpCode, this.status, this.message, this.dropOffList});

  DasboardApiResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
    if (json['responseData'] != null) {
      dropOffList = <DropOffList>[];
      json['responseData'].forEach((v) {
        dropOffList!.add(DropOffList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['httpCode'] = httpCode;
    data['status'] = status;
    data['message'] = message;
    if (dropOffList != null) {
      data['responseData'] = dropOffList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DropOffList {
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  String? fare;

  DropOffList(
      {this.name, this.address, this.latitude, this.longitude, this.fare});

  DropOffList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    fare = json['fare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['fare'] = fare;
    return data;
  }
}

DasboardApiResponse dashboardApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return DasboardApiResponse.fromJson(jsonData);
}

String dashboardApiRequestToJson(DasboardApiRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
