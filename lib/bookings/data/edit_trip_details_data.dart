import 'dart:convert';

import 'package:rsl_supervisor/bookings/data/edit_details_data.dart';

class EditCorporateBookingRequestData {
  int? id;
  int? motor_model;

  // int? car_make_id;
  CarMakeInfo? car_make_info;
  String? pickupTime;
  double? extraCharge;
  double? customerPrice;
  num? rsl_share;
  num? driver_share;
  num? corporate_share;
  String? remarks;
  int? zone_fare_applied;
  int? pickup_zone_id;
  int? pickup_zone_group_id;
  int? drop_zone_id;
  int? drop_zone_group_id;
  String? currentLocation;
  String? dropLocation;
  String? passengerPaymentOption;
  String? finalPaymentOption;
  double? pickupLatitude;
  double? pickupLongitude;
  double? dropLatitude;
  double? dropLongitude;
  String? guestEmail;
  String? guestName;
  String? guestPhone;
  String? guestCountryCode;
  String? approx_distance;
  String? approx_duration;
  double? approx_trip_fare;
  String? customer_rate;
  int? now_after;
  int? package_id;
  int? package_type;
  int? trip_type;
  int? double_the_fare;
  String? roomNo;
  String? pickupNotes;
  String? dropNotes;
  String? noteToDriver;
  String? flightNumber;
  String? referenceNumber;
  String? noteToAdmin;
  String? route_polyline;

  EditCorporateBookingRequestData(
      {this.id,
      this.motor_model,
      // this.car_make_id,
      this.car_make_info,
      this.pickupTime,
      this.extraCharge,
      this.rsl_share,
      this.driver_share,
      this.corporate_share,
      this.remarks,
      this.zone_fare_applied,
      this.pickup_zone_id,
      this.pickup_zone_group_id,
      this.drop_zone_id,
      this.drop_zone_group_id,
      this.currentLocation,
      this.dropLocation,
      this.customerPrice,
      this.pickupNotes,
      this.dropNotes,
      this.passengerPaymentOption,
      this.finalPaymentOption,
      this.pickupLatitude,
      this.pickupLongitude,
      this.dropLatitude,
      this.dropLongitude,
      this.guestEmail,
      this.guestName,
      this.guestPhone,
      this.guestCountryCode,
      this.approx_distance,
      this.approx_duration,
      this.approx_trip_fare,
      this.customer_rate,
      this.package_id,
      this.package_type,
      this.trip_type,
      this.double_the_fare,
      this.roomNo,
      this.noteToDriver,
      this.flightNumber,
      this.referenceNumber,
      this.noteToAdmin,
      this.now_after,
      this.route_polyline});

  EditCorporateBookingRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    motor_model = json['motor_model'];
    // car_make_id = json['car_make_id'];
    car_make_info = json['car_make_info'] != null
        ? CarMakeInfo.fromJson(json['car_make_info'])
        : null;
    pickupTime = json['pickup_time'];
    currentLocation = json['current_location'];
    dropLocation = json['drop_location'];
    customerPrice = json['customer_price'];
    pickupNotes = json['pickup_notes'];
    dropNotes = json['drop_notes'];
    passengerPaymentOption = json['passenger_payment_option'];
    finalPaymentOption = json['final_payment_option'];
    pickupLatitude = json['pickup_latitude'];
    pickupLongitude = json['pickup_longitude'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    guestEmail = json['guest_email'];
    guestName = json['guest_name'];
    guestPhone = json['guest_phone'];
    guestCountryCode = json['guest_country_code'];
    extraCharge = json['extra_charge'];
    rsl_share = json['rsl_share'];
    driver_share = json['driver_share'];
    corporate_share = json['corporate_share'];
    remarks = json['remarks'];
    zone_fare_applied = json['zone_fare_applied'];
    pickup_zone_id = json['pickup_zone_id'];
    pickup_zone_group_id = json['pickup_zone_group_id'];
    drop_zone_id = json['drop_zone_id'];
    drop_zone_group_id = json['drop_zone_group_id'];
    approx_distance = json['approx_distance'];
    approx_duration = json['approx_duration'];
    approx_trip_fare = json['approx_trip_fare'];
    noteToDriver = json['note_to_driver'];
    flightNumber = json['flight_number'];
    referenceNumber = json['reference_number'];
    noteToAdmin = json['note_to_admin'];
    roomNo = json['room_number'];
    now_after = json['now_after'];
    customer_rate = json['customer_rate'];
    package_id = json['package_id'];
    package_type = json['package_type'];
    trip_type = json['trip_type'];
    double_the_fare = json['double_the_fare'];
    route_polyline = json['route_polyline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['motor_model'] = motor_model;
    // data['car_make_id'] = car_make_id;
    if (car_make_info != null) {
      data['car_make_info'] = car_make_info!.toJson();
    }
    data['pickup_time'] = pickupTime;
    data['current_location'] = currentLocation;
    data['drop_location'] = dropLocation;
    data['customer_price'] = customerPrice;
    data['pickup_notes'] = pickupNotes;
    data['drop_notes'] = dropNotes;
    data['passenger_payment_option'] = passengerPaymentOption;
    data['final_payment_option'] = finalPaymentOption;
    data['pickup_latitude'] = pickupLatitude;
    data['pickup_longitude'] = pickupLongitude;
    data['drop_latitude'] = dropLatitude;
    data['drop_longitude'] = dropLongitude;
    data['guest_email'] = guestEmail;
    data['guest_name'] = guestName;
    data['guest_phone'] = guestPhone;
    data['guest_country_code'] = guestCountryCode;
    data['extra_charge'] = extraCharge;
    data['rsl_share'] = rsl_share;
    data['driver_share'] = driver_share;
    data['corporate_share'] = corporate_share;
    data['remarks'] = remarks;
    data['zone_fare_applied'] = zone_fare_applied;
    data['pickup_zone_id'] = pickup_zone_id;
    data['pickup_zone_group_id'] = pickup_zone_group_id;
    data['drop_zone_id'] = drop_zone_id;
    data['drop_zone_group_id'] = drop_zone_group_id;
    data['approx_distance'] = approx_distance;
    data['approx_duration'] = approx_duration;
    data['approx_trip_fare'] = approx_trip_fare;
    data['customer_rate'] = customer_rate;
    data['note_to_driver'] = noteToDriver;
    data['flight_number'] = flightNumber;
    data['reference_number'] = referenceNumber;
    data['note_to_admin'] = noteToAdmin;
    data['now_after'] = now_after;
    data['package_id'] = package_id;
    data['package_type'] = package_type;
    data['trip_type'] = trip_type;
    data['double_the_fare'] = double_the_fare;
    data['route_polyline'] = route_polyline;
    data['room_number'] = roomNo;
    return data;
  }
}

class EditCorporateBookingResponseData {
  int? httpCode;
  int? status;
  String? message;

  EditCorporateBookingResponseData({this.httpCode, this.status, this.message});

  EditCorporateBookingResponseData.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['httpCode'] = httpCode;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

EditCorporateBookingResponseData editCorporateBookingResponseFromJson(
    String str) {
  final jsonData = json.decode(str);
  return EditCorporateBookingResponseData.fromJson(jsonData);
}

String editCorporateBookingRequestToJson(EditCorporateBookingRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
