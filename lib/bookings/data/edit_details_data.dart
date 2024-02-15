import 'dart:convert';

class GetByPassengerEditDetailsRequest {
  String? id;

  GetByPassengerEditDetailsRequest({
    this.id,
  });

  GetByPassengerEditDetailsRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class GetByPassengerEditDetailsResponse {
  String? message;
  int? status;
  PassengerDetails? responseData;

  GetByPassengerEditDetailsResponse(
      {this.message, this.status, this.responseData});

  GetByPassengerEditDetailsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    responseData = json['responseDate'] != null
        ? PassengerDetails.fromJson(json['responseDate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (responseData != null) {
      data['responseDate'] = responseData!.toJson();
    }
    return data;
  }
}

class PassengerDetails {
  int? id;
  double? pickup_latitude;
  double? pickup_longitude;
  double? drop_latitude;
  double? drop_longitude;
  String? current_location;
  String? drop_location;
  String? pickup_time;
  String? pickup_notes;
  String? drop_notes;
  String? passenger_payment_option;
  MotorModelInfo? motor_model_info;
  CarMakeInfo? car_make_info;
  num? customer_price;
  String? note_to_driver;
  String? note_to_admin;
  String? flight_number;
  String? reference_number;
  String? room_number;
  String? guest_name;
  String? guest_country_code;
  String? guest_phone;
  String? guest_email;
  num? rsl_share;
  num? driver_share;
  num? corporate_share;
  num? extra_charge;
  String? remarks;
  num? customer_rate;
  int? zone_fare_applied;
  int? pickup_zone_id;
  int? pickup_zone_group_id;
  int? drop_zone_id;
  int? drop_zone_group_id;
  num? approx_distance;
  num? approx_duration;
  num? approx_trip_fare;
  int? now_after;
  int? package_id;
  int? package_type;
  int? trip_type;
  int? double_the_fare;
  String? route_polyline;

  PassengerDetails({
    this.id,
    this.pickup_latitude,
    this.pickup_longitude,
    this.drop_latitude,
    this.drop_longitude,
    this.current_location,
    this.drop_location,
    this.pickup_time,
    this.pickup_notes,
    this.drop_notes,
    this.passenger_payment_option,
    this.motor_model_info,
    this.car_make_info,
    this.customer_price,
    this.note_to_driver,
    this.note_to_admin,
    this.flight_number,
    this.reference_number,
    this.guest_name,
    this.guest_country_code,
    this.guest_phone,
    this.guest_email,
    this.rsl_share,
    this.driver_share,
    this.corporate_share,
    this.extra_charge,
    this.remarks,
    this.customer_rate,
    this.zone_fare_applied,
    this.pickup_zone_id,
    this.pickup_zone_group_id,
    this.drop_zone_id,
    this.drop_zone_group_id,
    this.approx_distance,
    this.approx_duration,
    this.approx_trip_fare,
    this.room_number,
    this.now_after,
    this.package_id,
    this.package_type,
    this.trip_type,
    this.double_the_fare,
    this.route_polyline,
  });

  PassengerDetails.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    pickup_latitude = json['pickup_latitude'];
    pickup_longitude = json['pickup_longitude'];
    drop_latitude = json['drop_latitude'];
    drop_longitude = json['drop_longitude'];
    current_location = json['current_location'];
    drop_location = json['drop_location'];
    pickup_time = json['pickup_time'];
    pickup_notes = json['pickup_notes'];
    drop_notes = json['drop_notes'];
    passenger_payment_option = json['passenger_payment_option'];
    motor_model_info = json['motor_model_info'] != null
        ? MotorModelInfo.fromJson(json['motor_model_info'])
        : null;
    car_make_info = json['car_make_info'] != null
        ? CarMakeInfo.fromJson(json['car_make_info'])
        : null;
    customer_price = json['customer_price'];
    note_to_driver = json['note_to_driver'];
    note_to_admin = json['note_to_admin'];
    flight_number = json['flight_number'];
    reference_number = json['reference_number'];
    guest_name = json['guest_name'];
    guest_country_code = json['guest_country_code'];
    guest_phone = json['guest_phone'];
    guest_email = json['guest_email'];
    rsl_share = json['rsl_share'];
    driver_share = json['driver_share'];
    corporate_share = json['corporate_share'];
    extra_charge = json['extra_charge'];
    remarks = json['remarks'];
    customer_rate = json['customer_rate'];
    zone_fare_applied = json['zone_fare_applied'];
    pickup_zone_id = json['pickup_zone_id'];
    pickup_zone_group_id = json['pickup_zone_group_id'];
    drop_zone_id = json['drop_zone_id'];
    drop_zone_group_id = json['drop_zone_group_id'];
    approx_distance = json['approx_distance'];
    approx_duration = json['approx_duration'];
    approx_trip_fare = json['approx_fare'];
    room_number = json['room_number'];
    now_after = json['now_after'];
    package_id = json['package_id'];
    package_type = json['package_type'];
    trip_type = json['mobile_trip_type'];
    double_the_fare = json['mobile_double_the_fare'];
    route_polyline = json['route_polyline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['pickup_latitude'] = pickup_latitude;
    data['pickup_longitude'] = pickup_longitude;
    data['drop_latitude'] = drop_latitude;
    data['drop_longitude'] = drop_longitude;
    data['current_location'] = current_location;
    data['drop_location'] = drop_location;
    data['pickup_time'] = pickup_time;
    data['pickup_notes'] = pickup_notes;
    data['drop_notes'] = drop_notes;
    data['passenger_payment_option'] = passenger_payment_option;
    if (motor_model_info != null) {
      data['motor_model_info'] = motor_model_info!.toJson();
    }
    if (car_make_info != null) {
      data['car_make_info'] = car_make_info!.toJson();
    }
    data['customer_price'] = customer_price;
    data['note_to_driver'] = note_to_driver;
    data['note_to_admin'] = note_to_admin;
    data['flight_number'] = flight_number;
    data['reference_number'] = reference_number;
    data['guest_name'] = guest_name;
    data['guest_country_code'] = guest_country_code;
    data['guest_phone'] = guest_phone;
    data['guest_email'] = guest_email;
    data['rsl_share'] = rsl_share;
    data['driver_share'] = driver_share;
    data['corporate_share'] = corporate_share;
    data['extra_charge'] = extra_charge;
    data['remarks'] = remarks;
    data['customer_rate'] = customer_rate;
    data['zone_fare_applied'] = zone_fare_applied;
    data['pickup_zone_id'] = pickup_zone_id;
    data['pickup_zone_group_id'] = pickup_zone_group_id;
    data['drop_zone_id'] = drop_zone_id;
    data['drop_zone_group_id'] = drop_zone_group_id;
    data['approx_distance'] = approx_distance;
    data['approx_duration'] = approx_duration;
    data['approx_fare'] = approx_trip_fare;
    data['room_number'] = room_number;
    data['now_after'] = now_after;
    data['package_id'] = package_id;
    data['package_type'] = package_type;
    data['mobile_trip_type'] = trip_type;
    data['mobile_double_the_fare'] = double_the_fare;
    data['route_polyline'] = route_polyline;
    return data;
  }
}

class MotorModelInfo {
  int? modelId;
  String? modelName;
  int? cancellationFare;
  int? minFare;
  int? taxiMinSpeed;
  int? taxiSpeed;
  int? waitingTime;

  MotorModelInfo(
      {this.modelId,
      this.modelName,
      this.cancellationFare,
      this.minFare,
      this.taxiMinSpeed,
      this.taxiSpeed,
      this.waitingTime});

  MotorModelInfo.fromJson(Map<String, dynamic> json) {
    modelId = json['model_id'];
    modelName = json['model_name'];
    cancellationFare = json['cancellation_fare'];
    minFare = json['min_fare'];
    taxiMinSpeed = json['taxi_min_speed'];
    taxiSpeed = json['taxi_speed'];
    waitingTime = json['waiting_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model_id'] = modelId;
    data['model_name'] = modelName;
    data['cancellation_fare'] = cancellationFare;
    data['min_fare'] = minFare;
    data['taxi_min_speed'] = taxiMinSpeed;
    data['taxi_speed'] = taxiSpeed;
    data['waiting_time'] = waitingTime;
    return data;
  }
}

class CarMakeInfo {
  int? car_make_id;
  String? car_make_name;

  CarMakeInfo({
    this.car_make_id,
    this.car_make_name,
  });

  CarMakeInfo.fromJson(Map<String, dynamic> json) {
    car_make_id = json['car_make_id'];
    car_make_name = json['car_make_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['car_make_id'] = car_make_id;
    data['car_make_name'] = car_make_name;

    return data;
  }
}

/*class MotorModelInfo {
  int? model_id;
  String? model_name;

  MotorModelInfo(this.model_id, this.model_name);

  MotorModelInfo.fromJson(Map<String, dynamic> json) {
    model_id = json['model_id'];
    model_name = json['model_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model_id'] = model_id;
    data['model_name'] = model_name;
    return data;
  }
}*/

GetByPassengerEditDetailsResponse getByPassengerEditDetailsFromJson(
    String str) {
  final jsonData = json.decode(str);
  return GetByPassengerEditDetailsResponse.fromJson(jsonData);
}

String getByPassengerEditDetailsRequestToJson(
    GetByPassengerEditDetailsRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
