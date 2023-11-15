import 'dart:convert';

class DispatchQuickTripRequestData {
  String? kioskId;
  String? tripId;
  String? companyId;
  String? supervisorName;
  String? supervisorId;
  String? supervisorUniqueId;
  String? name;
  String? countryCode;
  String? mobileNo;
  String? email;
  String? fixedMeter;
  String? kioskFare;
  String? paymentId;
  double? dropLatitude;
  double? dropLongitude;
  String? dropplace;
  String? referenceNumber;

  DispatchQuickTripRequestData(
      {this.kioskId,
      this.tripId,
      this.companyId,
      this.supervisorName,
      this.supervisorId,
      this.supervisorUniqueId,
      this.name,
      this.countryCode,
      this.mobileNo,
      this.email,
      this.fixedMeter,
      this.kioskFare,
      this.paymentId,
      this.dropLatitude,
      this.dropLongitude,
      this.dropplace,
      this.referenceNumber});

  DispatchQuickTripRequestData.fromJson(Map<String, dynamic> json) {
    kioskId = json['kiosk_id'];
    tripId = json['trip_id'];
    companyId = json['company_id'];
    supervisorName = json['supervisor_name'];
    supervisorId = json['supervisor_id'];
    supervisorUniqueId = json['supervisor_unique_id'];
    name = json['name'];
    countryCode = json['country_code'];
    mobileNo = json['mobile_no'];
    email = json['email'];
    fixedMeter = json['fixed_meter'];
    kioskFare = json['kiosk_fare'];
    paymentId = json['payment_id'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    dropplace = json['dropplace'];
    referenceNumber = json['reference_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kiosk_id'] = this.kioskId;
    data['trip_id'] = this.tripId;
    data['company_id'] = this.companyId;
    data['supervisor_name'] = this.supervisorName;
    data['supervisor_id'] = this.supervisorId;
    data['supervisor_unique_id'] = this.supervisorUniqueId;
    data['name'] = this.name;
    data['country_code'] = this.countryCode;
    data['mobile_no'] = this.mobileNo;
    data['email'] = this.email;
    data['fixed_meter'] = this.fixedMeter;
    data['kiosk_fare'] = this.kioskFare;
    data['payment_id'] = this.paymentId;
    data['drop_latitude'] = this.dropLatitude;
    data['drop_longitude'] = this.dropLongitude;
    data['dropplace'] = this.dropplace;
    data['reference_number'] = this.referenceNumber;
    return data;
  }
}

class DispatchQuickTripResponseData {
  String? message;
  int? status;
  String? trackUrl;

  DispatchQuickTripResponseData({this.message, this.status, this.trackUrl});

  DispatchQuickTripResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    trackUrl = '${json['track_url']}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['track_url'] = trackUrl;
    return data;
  }
}

DispatchQuickTripResponseData dispatchQuickTripResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return DispatchQuickTripResponseData.fromJson(jsonData);
}

String dispatchQuickTripRequestToJson(DispatchQuickTripRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
