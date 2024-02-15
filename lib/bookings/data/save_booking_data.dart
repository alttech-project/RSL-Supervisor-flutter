import 'dart:convert';

class SaveBookingRequest {
  String? approx_distance;
  String? approx_duration;
  double? approx_trip_fare;
  double? drop_latitude;
  double? drop_longitude;
  String? dropplace;
  String? guest_name;
  String? guest_country_code;
  String? guest_phone;
  String? guest_email;
  double? latitude;
  double? longitude;
  int? motor_model;
  int? now_after;
  int? corporate_id;
  int? passenger_payment_option;
  String? pickupplace;
  String? pickup_time;
  String? note_to_driver;
  String? note_to_admin;
  String? flight_number;
  String? reference_number;
  num? customer_price;
  String? customer_rate;
  String? extra_charge;
  String? remarks;

  String? roomNo;

  int? zone_fare_applied;
  num? rsl_share;
  num? driver_share;
  num? corporate_share;
  int? pickup_zone_id;
  int? pickup_zone_group_id;
  int? drop_zone_id;
  int? drop_zone_group_id;
  int? package_id;
  int? package_type;
  int? trip_type;
  int? double_the_fare;
  String? supervisorId;
  String? kioskId;
  String? cid;
  String? route_polyline;

  SaveBookingRequest({
    this.approx_distance,
    this.approx_duration,
    this.approx_trip_fare,
    this.drop_latitude,
    this.drop_longitude,
    this.dropplace,
    this.guest_name,
    this.guest_country_code,
    this.guest_phone,
    this.guest_email,
    this.latitude,
    this.longitude,
    this.motor_model,
    this.now_after,
    this.corporate_id,
    this.passenger_payment_option,
    this.pickupplace,
    this.pickup_time,
    this.note_to_driver,
    this.note_to_admin,
    this.flight_number,
    this.reference_number,
    this.customer_price,
    this.customer_rate,
    this.extra_charge,
    this.remarks,
    this.zone_fare_applied,
    this.rsl_share,
    this.driver_share,
    this.corporate_share,
    this.pickup_zone_id,
    this.pickup_zone_group_id,
    this.drop_zone_id,
    this.drop_zone_group_id,
    this.package_id,
    this.package_type,
    this.trip_type,
    this.double_the_fare,
    this.supervisorId,
    this.kioskId,
    this.cid,
    this.roomNo,
    this.route_polyline,
  });

  SaveBookingRequest.fromJson(Map<String, dynamic> json) {
    approx_distance = json['approx_distance'];
    approx_duration = json['approx_duration'];
    approx_trip_fare = json['approx_trip_fare'];
    drop_latitude = json['drop_latitude'];
    drop_longitude = json['drop_longitude'];
    dropplace = json['dropplace'];
    guest_name = json['guest_name'];
    guest_country_code = json['guest_country_code'];
    guest_phone = json['guest_phone'];
    guest_email = json['guest_email'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    motor_model = json['motor_model'];
    now_after = json['now_after'];
    corporate_id = json['corporate_id'];
    corporate_share = json['corporate_share'];
    passenger_payment_option = json['passenger_payment_option'];
    pickupplace = json['pickupplace'];
    pickup_time = json['pickup_time'];
    note_to_driver = json['note_to_driver'];
    note_to_admin = json['note_to_admin'];
    flight_number = json['flight_number'];
    reference_number = json['reference_number'];
    customer_price = json['customer_price'];
    customer_rate = json['customer_rate'];
    rsl_share = json['rsl_share'];
    driver_share = json['driver_share'];
    extra_charge = json['extra_charge'];
    remarks = json['remarks'];
    zone_fare_applied = json['zone_fare_applied'];
    pickup_zone_id = json['pickup_zone_id'];
    pickup_zone_group_id = json['pickup_zone_group_id'];
    drop_zone_id = json['drop_zone_id'];
    drop_zone_group_id = json['drop_zone_group_id'];
    package_id = json['package_id'];
    package_type = json['package_type'];
    trip_type = json['trip_type'];
    double_the_fare = json['double_the_fare'];
    supervisorId = json['supervisor_id'];
    kioskId = json['kiosk_id'];
    cid = json['company_id'];
    roomNo = json['room_number'];
    route_polyline = json['route_polyline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['approx_distance'] = approx_distance;
    data['approx_duration'] = approx_duration;
    data['approx_trip_fare'] = approx_trip_fare;
    data['drop_latitude'] = drop_latitude;
    data['drop_longitude'] = drop_longitude;
    data['dropplace'] = dropplace;
    data['guest_name'] = guest_name;
    data['guest_country_code'] = guest_country_code;
    data['guest_phone'] = guest_phone;
    data['guest_email'] = guest_email;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['motor_model'] = motor_model;
    data['now_after'] = now_after;
    data['corporate_id'] = corporate_id;
    data['corporate_share'] = corporate_share;
    data['passenger_payment_option'] = passenger_payment_option;
    data['pickupplace'] = pickupplace;
    data['pickup_time'] = pickup_time;
    data['note_to_driver'] = note_to_driver;
    data['note_to_admin'] = note_to_admin;
    data['flight_number'] = flight_number;
    data['reference_number'] = reference_number;
    data['customer_price'] = customer_price;
    data['customer_rate'] = customer_rate;
    data['rsl_share'] = rsl_share;
    data['driver_share'] = driver_share;
    data['extra_charge'] = extra_charge;
    data['remarks'] = remarks;
    data['zone_fare_applied'] = zone_fare_applied;
    data['pickup_zone_id'] = pickup_zone_id;
    data['pickup_zone_group_id'] = pickup_zone_group_id;
    data['drop_zone_id'] = drop_zone_id;
    data['drop_zone_group_id'] = drop_zone_group_id;
    data['package_id'] = package_id;
    data['package_type'] = package_type;
    data['trip_type'] = trip_type;
    data['double_the_fare'] = double_the_fare;
    data['supervisor_id'] = supervisorId;
    data['kiosk_id'] = kioskId;
    data['company_id'] = cid;
    data['room_number'] = roomNo;
    data['route_polyline'] = route_polyline;
    return data;
  }
}

class SaveBookingResponse {
  String? message;
  int? status;
  String? authKey;

  SaveBookingResponse({this.message, this.status, this.authKey});

  SaveBookingResponse.fromJson(Map<String, dynamic> json) {
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

SaveBookingResponse saveBookingResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return SaveBookingResponse.fromJson(jsonData);
}

String saveBookingRequestToJson(SaveBookingRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
