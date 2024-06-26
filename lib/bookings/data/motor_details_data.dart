import 'dart:convert';

class Payments {
  final String name;
  final String paymentId;

  const Payments({
    required this.name,
    required this.paymentId,
  });
}

const List<Payments> paymentList = <Payments>[
  Payments(
    name: 'BILL',
    paymentId: "7",
  ),
  Payments(
    name: 'CASH',
    paymentId: "1",
  ),
  Payments(
    name: 'COMPLIMENTARY',
    paymentId: "8",
  ),
  Payments(
    name: 'POS',
    paymentId: "9",
  ),
];

const List<Payments> quickTripsPaymentList = <Payments>[
  Payments(
    name: 'POS',
    paymentId: "9",
  ),
  Payments(
    name: 'CASH',
    paymentId: "1",
  ),
  Payments(
    name: 'BILL',
    paymentId: "7",
  ),
  Payments(
    name: 'COMPLIMENTARY',
    paymentId: "8",
  ),
];

class TripType {
  final String name;
  final int id;

  const TripType({
    required this.name,
    required this.id,
  });
}

const List<TripType> bookingTypeList = <TripType>[
  TripType(
    name: 'Normal Booking',
    id: 1,
  ),
  TripType(
    name: 'Package Booking',
    id: 3,
  ),
];

const List<TripType> packageTypeList = <TripType>[
  TripType(
    name: 'Hours',
    id: 1,
  ),
  TripType(
    name: 'Days',
    id: 2,
  ),
];

class MotorDetailsRequest {
  String? supervisorId;
  String? kioskId;
  String? corporateId;
  String? cid;
  double? pickup_latitude;
  double? pickup_longitude;
  double? drop_latitude;
  double? drop_longitude;
  double? distance;

  MotorDetailsRequest(
      {this.supervisorId,
      this.kioskId,
      this.corporateId,
      this.cid,
      this.pickup_latitude,
      this.pickup_longitude,
      this.drop_latitude,
      this.drop_longitude,
      this.distance});

  MotorDetailsRequest.fromJson(Map<String, dynamic> json) {
    supervisorId = json['supervisor_id'];
    kioskId = json['kiosk_id'];
    corporateId = json['corporate_id'];
    cid = json['company_id'];
    pickup_latitude = json['pickup_latitude'];
    pickup_longitude = json['pickup_longitude'];
    drop_latitude = json['drop_latitude'];
    drop_longitude = json['drop_longitude'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supervisor_id'] = supervisorId;
    data['kiosk_id'] = kioskId;
    data['corporate_id'] = corporateId;
    data['company_id'] = cid;
    data['pickup_latitude'] = pickup_latitude;
    data['pickup_longitude'] = pickup_longitude;
    data['drop_latitude'] = drop_latitude;
    data['drop_longitude'] = drop_longitude;
    data['distance'] = distance;
    return data;
  }
}

class MotorDetailsResponse {
  String? message;
  int? status;
  String? authKey;
  List<FareDetailList>? fareDetailList;

  MotorDetailsResponse(
      {this.message, this.fareDetailList, this.status, this.authKey});

  MotorDetailsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    authKey = json['auth_key'];
    if (json['responseData'] != null) {
      fareDetailList = <FareDetailList>[];
      json['responseData'].forEach((v) {
        fareDetailList!.add(new FareDetailList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['auth_key'] = authKey;
    if (this.fareDetailList != null) {
      data['responseData'] =
          this.fareDetailList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FareDetailList {
  int? modelId;
  String? modelName;
  num? fare;
  num? driverShare;
  num? rslShare;
  num? corporateShare;
  int? zoneFareApplied;
  int? pickupZoneGroupId;
  int? pickupZoneId;
  int? dropZoneId;
  int? dropZoneGroupId;
  String? beforeSelect;

  FareDetailList(
      {this.modelId,
      this.modelName,
      this.fare,
      this.driverShare,
      this.rslShare,
      this.corporateShare,
      this.zoneFareApplied,
      this.pickupZoneGroupId,
      this.pickupZoneId,
      this.dropZoneId,
      this.dropZoneGroupId,
      this.beforeSelect});

  FareDetailList.fromJson(Map<String, dynamic> json) {
    modelId = json['model_id'];
    modelName = json['model_name'];
    fare = json['fare'];
    driverShare = json['driver_share'];
    rslShare = json['rsl_share'];
    corporateShare = json['corporate_share'];
    zoneFareApplied = json['zone_fare_applied'];
    pickupZoneGroupId = json['pickup_zone_group_id'];
    pickupZoneId = json['pickup_zone_id'];
    dropZoneId = json['drop_zone_id'];
    dropZoneGroupId = json['drop_zone_group_id'];
    beforeSelect = json["beforeSelect"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_id'] = this.modelId;
    data['model_name'] = this.modelName;
    data['fare'] = this.fare;
    data['driver_share'] = driverShare;
    data['rsl_share'] = rslShare;
    data['corporate_share'] = corporateShare;
    data['zone_fare_applied'] = zoneFareApplied;
    data['pickup_zone_group_id'] = pickupZoneGroupId;
    data['pickup_zone_id'] = pickupZoneId;
    data['drop_zone_id'] = dropZoneId;
    data['drop_zone_group_id'] = dropZoneGroupId;
    data["beforeSelect"] = beforeSelect;
    return data;
  }
}

MotorDetailsResponse motorDetailsResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return MotorDetailsResponse.fromJson(jsonData);
}

String motorDetailsRequestToJson(MotorDetailsRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
