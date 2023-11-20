import 'dart:convert';

import 'package:rsl_supervisor/bookings/data/edit_details_data.dart';

class EditCorporateBookingRequestData {
  int? id;
  String? pickupTime;
  MotorModelInfo? motorModelInfo;
  String? noteToDriver;
  String? flightNumber;
  String? referenceNumber;
  String? noteToAdmin;
  String? currentLocation;
  String? dropLocation;
  int? customerPrice;
  String? pickupNotes;
  String? dropNotes;
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
  String? remarks;
  int? extraCharge;

  EditCorporateBookingRequestData(
      {this.id,
      this.pickupTime,
      this.motorModelInfo,
      this.noteToDriver,
      this.flightNumber,
      this.referenceNumber,
      this.noteToAdmin,
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
      this.remarks,
      this.extraCharge});

  EditCorporateBookingRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pickupTime = json['pickup_time'];
    motorModelInfo = json['motor_model_info'] != null
        ? MotorModelInfo.fromJson(json['motor_model_info'])
        : null;
    noteToDriver = json['note_to_driver'];
    flightNumber = json['flight_number'];
    referenceNumber = json['reference_number'];
    noteToAdmin = json['note_to_admin'];
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
    remarks = json['remarks'];
    extraCharge = json['extraCharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pickup_time'] = pickupTime;
    if (motorModelInfo != null) {
      data['motor_model_info'] = motorModelInfo!.toJson();
    }
    data['note_to_driver'] = noteToDriver;
    data['flight_number'] = flightNumber;
    data['reference_number'] = referenceNumber;
    data['note_to_admin'] = noteToAdmin;
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
    data['remarks'] = remarks;
    data['extraCharge'] = extraCharge;
    return data;
  }
}

/*class MotorModelInfo {
  int? modelId;
  String? modelName;
  int? cancellationFare;
  int? minFare;
  int? taxiMinSpeed;
  int? taxiSpeed;

  MotorModelInfo(
      {this.modelId,
        this.modelName,
        this.cancellationFare,
        this.minFare,
        this.taxiMinSpeed,
        this.taxiSpeed});

  MotorModelInfo.fromJson(Map<String, dynamic> json) {
    modelId = json['model_id'];
    modelName = json['model_name'];
    cancellationFare = json['cancellation_fare'];
    minFare = json['min_fare'];
    taxiMinSpeed = json['taxi_min_speed'];
    taxiSpeed = json['taxi_speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model_id'] = modelId;
    data['model_name'] = modelName;
    data['cancellation_fare'] = cancellationFare;
    data['min_fare'] = minFare;
    data['taxi_min_speed'] = taxiMinSpeed;
    data['taxi_speed'] = taxiSpeed;
    return data;
  }
}*/

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
