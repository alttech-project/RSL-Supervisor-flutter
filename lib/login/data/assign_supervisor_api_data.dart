import 'dart:convert';

class AssignSupervisorRequest {
  int? kioskId;
  int? supervisorId;
  int? cid;
  double? latitude;
  double? longitude;
  double? accuracy;
  String? deviceToken;
  String? photoUrl;

  AssignSupervisorRequest(
      {this.kioskId,
      this.supervisorId,
      this.cid,
      this.latitude,
      this.longitude,
      this.accuracy,
      this.deviceToken,
      this.photoUrl});

  AssignSupervisorRequest.fromJson(Map<String, dynamic> json) {
    kioskId = json['kiosk_id'];
    supervisorId = json['supervisor_id'];
    cid = json['cid'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    accuracy = json['accuracy'];
    deviceToken = json['device_token'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kiosk_id'] = kioskId;
    data['supervisor_id'] = supervisorId;
    data['cid'] = cid;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['accuracy'] = accuracy;
    data['device_token'] = deviceToken;
    data['photo_url'] = photoUrl;
    return data;
  }
}

class AssignSupervisorResponse {
  String? message;
  String? supervisorMonitorLogUrl;
  int? status;
  int? locationType;
  int? corporateId;
  String? authKey;
  int? enableEditFare;
  int? quickTrip;
  int? customDropOff;
  int? quickTripDiscount;


  AssignSupervisorResponse(
      {this.message,
      this.supervisorMonitorLogUrl,
      this.status,
      this.authKey,
      this.locationType,
      this.corporateId,
      this.enableEditFare,
      this.quickTrip,
      this.customDropOff,
        this.quickTripDiscount,
      });

  AssignSupervisorResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    supervisorMonitorLogUrl = json['supervisor_monitor_log_url'];
    status = json['status'];
    authKey = json['auth_key'];
    locationType = json['location_type'];
    corporateId = json['corporate_id'];
    enableEditFare = json['enable_edit_fare'];
    quickTrip = json['quick_trip'];
    customDropOff = json['custom_drop_off'];
    quickTripDiscount = json['quick_trip_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['supervisor_monitor_log_url'] = supervisorMonitorLogUrl;
    data['status'] = status;
    data['auth_key'] = authKey;
    data['location_type'] = locationType;
    data['corporate_id'] = corporateId;
    data['enable_edit_fare'] = enableEditFare;
    data['quick_trip'] = quickTrip;
    data['custom_drop_off'] = customDropOff;
    data['quick_trip_discount'] = quickTripDiscount;
    return data;
  }
}

AssignSupervisorResponse assignSupervisorResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return AssignSupervisorResponse.fromJson(jsonData);
}

String assignSupervisorRequestToJson(AssignSupervisorRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
