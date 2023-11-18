import 'dart:convert';

class DispatchOfflineTripRequestData {
  double? dropLatitude;
  double? dropLongitude;
  String? fare;
  String? kioskId;
  String? taxiId;
  String? supervisorName;
  String? supervisorId;
  String? supervisorUniqueId;
  String? taxiModel;
  String? cid;
  String? name;
  String? countryCode;
  String? mobileNo;
  String? email;
  String? pickupDateTime;
  String? referenceNumber;
  String? remarks;

  DispatchOfflineTripRequestData(
      {this.dropLatitude,
      this.dropLongitude,
      this.fare,
      this.kioskId,
      this.taxiId,
      this.supervisorName,
      this.supervisorId,
      this.supervisorUniqueId,
      this.taxiModel,
      this.cid,
      this.name,
      this.countryCode,
      this.mobileNo,
      this.email,
      this.pickupDateTime,
      this.referenceNumber,
      this.remarks});

  DispatchOfflineTripRequestData.fromJson(Map<String, dynamic> json) {
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    fare = json['fare'];
    kioskId = json['kiosk_id'];
    taxiId = json['taxi_id'];
    supervisorName = json['supervisor_name'];
    supervisorId = json['supervisor_id'];
    supervisorUniqueId = json['supervisor_unique_id'];
    taxiModel = json['taxi_model'];
    cid = json['cid'];
    name = json['name'];
    countryCode = json['country_code'];
    mobileNo = json['mobile_no'];
    email = json['email'];
    pickupDateTime = json['pickup_date_time'];
    referenceNumber = json['reference_number'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['drop_latitude'] = dropLatitude;
    data['drop_longitude'] = dropLongitude;
    data['fare'] = fare;
    data['kiosk_id'] = kioskId;
    data['taxi_id'] = taxiId;
    data['supervisor_name'] = supervisorName;
    data['supervisor_id'] = supervisorId;
    data['supervisor_unique_id'] = supervisorUniqueId;
    data['taxi_model'] = taxiModel;
    data['cid'] = cid;
    data['name'] = name;
    data['country_code'] = countryCode;
    data['mobile_no'] = mobileNo;
    data['email'] = email;
    data['pickup_date_time'] = pickupDateTime;
    data['reference_number'] = referenceNumber;
    data['remarks'] = remarks;

    return data;
  }
}

class DispatchOfflineTripResponseData {
  String? message;
  int? status;

  DispatchOfflineTripResponseData({this.message, this.status});

  DispatchOfflineTripResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

DispatchOfflineTripResponseData dispatchOfflineTripResponseFromJson(
    String str) {
  final jsonData = json.decode(str);
  return DispatchOfflineTripResponseData.fromJson(jsonData);
}

String dispatchOfflineTripRequestToJson(DispatchOfflineTripRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
