import 'dart:convert';

class SaveBookingRequest {
  int? driverId;
  int? fixedMeter;
  String? kioskFare;
  String? kioskId;
  int? motorModel;
  String? pickupTime;
  String? pickupplace;
  String? tripMessage;
  String? supervisorName;
  String? supervisorId;
  int? zoneFareApplied;
  String? supervisorUniqueId;
  String? cid;
  String? name;
  String? countryCode;
  String? mobileNo;
  String? email;

  SaveBookingRequest({
    this.driverId,
    this.fixedMeter,
    this.kioskFare,
    this.kioskId,
    this.motorModel,
    this.pickupTime,
    this.pickupplace,
    this.tripMessage,
    this.supervisorName,
    this.supervisorId,
    this.zoneFareApplied,
    this.supervisorUniqueId,
    this.cid,
    this.name,
    this.countryCode,
    this.mobileNo,
    this.email,
  });

  SaveBookingRequest.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    fixedMeter = json['fixed_meter'];
    kioskFare = json['kiosk_fare'];
    kioskId = json['kiosk_id'];
    motorModel = json['motor_model'];
    pickupTime = json['pickup_time'];
    pickupplace = json['pickupplace'];
    tripMessage = json['trip_message'];
    supervisorName = json['supervisor_name'];
    supervisorId = json['supervisor_id'];
    zoneFareApplied = json['zone_fare_applied'];
    supervisorUniqueId = json['supervisor_unique_id'];
    cid = json['cid'];
    name = json['name'];
    countryCode = json['country_code'];
    mobileNo = json['mobile_no'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver_id'] = driverId;
    data['fixed_meter'] = fixedMeter;
    data['kiosk_fare'] = kioskFare;
    data['kiosk_id'] = kioskId;
    data['motor_model'] = motorModel;
    data['pickup_time'] = pickupTime;
    data['pickupplace'] = pickupplace;
    data['trip_message'] = tripMessage;
    data['supervisor_name'] = supervisorName;
    data['supervisor_id'] = supervisorId;
    data['zone_fare_applied'] = zoneFareApplied;
    data['supervisor_unique_id'] = supervisorUniqueId;
    data['cid'] = cid;
    data['name'] = name;
    data['country_code'] = countryCode;
    data['mobile_no'] = mobileNo;
    data['email'] = email;
    return data;
  }
}

class SaveBookingResponse {
  String? message;
  String? trackUrl;
  int? status;
  int? tripId;
  int? selecteDriver;
  String? pickupLocation;
  String? dropLocation;
  String? pickupTime;
  int? fare;
  String? kioskMessage;
  String? taxiNo;
  String? driverName;
  String? driverPhone;
  String? taxiModel;
  String? authKey;

  SaveBookingResponse({
    this.message,
    this.trackUrl,
    this.status,
    this.tripId,
    this.selecteDriver,
    this.pickupLocation,
    this.dropLocation,
    this.pickupTime,
    this.fare,
    this.kioskMessage,
    this.taxiNo,
    this.driverName,
    this.driverPhone,
    this.taxiModel,
    this.authKey,
  });

  SaveBookingResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    trackUrl = json['track_url'];
    status = json['status'];
    tripId = json['trip_id'];
    selecteDriver = json['selecteDriver'];
    pickupLocation = json['pickup_location'];
    dropLocation = json['drop_location'];
    pickupTime = json['pickup_time'];
    fare = json['fare'];
    kioskMessage = json['kiosk_message'];
    taxiNo = json['taxi_no'];
    driverName = json['driver_name'];
    driverPhone = json['driver_phone'];
    taxiModel = json['taxi_model'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['track_url'] = trackUrl;
    data['status'] = status;
    data['trip_id'] = tripId;
    data['selecteDriver'] = selecteDriver;
    data['pickup_location'] = pickupLocation;
    data['drop_location'] = dropLocation;
    data['pickup_time'] = pickupTime;
    data['fare'] = fare;
    data['kiosk_message'] = kioskMessage;
    data['taxi_no'] = taxiNo;
    data['driver_name'] = driverName;
    data['driver_phone'] = driverPhone;
    data['taxi_model'] = taxiModel;
    data['auth_key'] = authKey;
    return data;
  }
}

String saveBookingRequestToJson(SaveBookingRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

SaveBookingResponse saveBookingResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return SaveBookingResponse.fromJson(jsonData);
}
