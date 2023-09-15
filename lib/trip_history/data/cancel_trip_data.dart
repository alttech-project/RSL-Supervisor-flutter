import 'dart:convert';

class CancelTripRequest {
  String? cancelPwd;
  String? kioskId;
  int? tripId;
  String? cancelMessage;
  String? cid;

  CancelTripRequest(
      {this.cancelPwd,
      this.kioskId,
      this.tripId,
      this.cancelMessage,
      this.cid});

  CancelTripRequest.fromJson(Map<String, dynamic> json) {
    cancelPwd = json['cancel_pwd'];
    kioskId = json['kiosk_id'];
    tripId = json['trip_id'];
    cancelMessage = json['cancel_message'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cancel_pwd'] = cancelPwd;
    data['kiosk_id'] = kioskId;
    data['trip_id'] = tripId;
    data['cancel_message'] = cancelMessage;
    data['cid'] = cid;
    return data;
  }
}

class CancelTripResponse {
  String? message;
  int? status;
  int? tripId;
  String? authKey;

  CancelTripResponse({this.message, this.status, this.tripId, this.authKey});

  CancelTripResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    tripId = json['trip_id'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['trip_id'] = tripId;
    data['auth_key'] = authKey;
    return data;
  }
}
class EditFareRequestData {
  int? tripId;
  int? fare;
  String? comments;

  EditFareRequestData({this.tripId, this.fare, this.comments});

  EditFareRequestData.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    fare = json['fare'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_id'] = this.tripId;
    data['fare'] = this.fare;
    data['comments'] = this.comments;
    return data;
  }
}

class EditFareResponseData {
  String? message;
  String? details;
  int? status;
  String? authKey;

  EditFareResponseData({this.message, this.details, this.status, this.authKey});

  EditFareResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    details = json['details'];
    status = json['status'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['details'] = this.details;
    data['status'] = this.status;
    data['auth_key'] = this.authKey;
    return data;
  }
}


String cancelTripRequestToJson(CancelTripRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

CancelTripResponse camcelTripResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return CancelTripResponse.fromJson(jsonData);
}

String editFareRequestToJson(EditFareRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

EditFareResponseData editFareResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return EditFareResponseData.fromJson(jsonData);
}