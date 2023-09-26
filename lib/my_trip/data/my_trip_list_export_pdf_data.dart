


import 'dart:convert';

class ExportPdfRequestData {
  String? driverId;
  String? from;
  String? to;
  String? locationId;
  String? supervisorId;
  String? tripId;
  String? cid;

  ExportPdfRequestData(
      {this.driverId,
        this.from,
        this.to,
        this.locationId,
        this.supervisorId,
        this.tripId,
        this.cid});

  ExportPdfRequestData.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    from = json['from'];
    to = json['to'];
    locationId = json['location_id'];
    supervisorId = json['supervisor_id'];
    tripId = json['trip_id'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_id'] = this.driverId;
    data['from'] = this.from;
    data['to'] = this.to;
    data['location_id'] = this.locationId;
    data['supervisor_id'] = this.supervisorId;
    data['trip_id'] = this.tripId;
    data['cid'] = this.cid;
    return data;
  }
}


class ExportPdfResponseData {
  String? message;
  int? status;
  String? authKey;

  ExportPdfResponseData({this.message, this.status, this.authKey});

  ExportPdfResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['auth_key'] = this.authKey;
    return data;
  }
}


String tripListexportPdfRequestToJson(ExportPdfRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

ExportPdfResponseData tripListexportPdfResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return ExportPdfResponseData.fromJson(jsonData);
}