import 'dart:convert';

class tripListCancelTripRequest {
  String? cancelPwd;
  String? kioskId;
  int? tripId;
  String? cancelMessage;
  String? cid;

  tripListCancelTripRequest(
      {this.cancelPwd,
        this.kioskId,
        this.tripId,
        this.cancelMessage,
        this.cid});

  tripListCancelTripRequest.fromJson(Map<String, dynamic> json) {
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

class tripListCancelTripResponse {
  String? message;
  int? status;
  int? tripId;
  String? authKey;

  tripListCancelTripResponse({this.message, this.status, this.tripId, this.authKey});

  tripListCancelTripResponse.fromJson(Map<String, dynamic> json) {
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








String cancelTripRequestToJson(tripListCancelTripRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

tripListCancelTripResponse cancelTripResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return tripListCancelTripResponse.fromJson(jsonData);
}




