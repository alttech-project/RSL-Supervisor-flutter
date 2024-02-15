import 'dart:convert';

class CarMakeFareRequest {
  String? supervisorId;
  String? kioskId;
  String? corporateId;
  double? pickup_latitude;
  double? pickup_longitude;
  double? drop_latitude;
  double? drop_longitude;
  String? cid;
  double? distance;
  String? modelId;
  String? carMakeId;

  CarMakeFareRequest(
      {this.supervisorId,
      this.kioskId,
      this.corporateId,
      this.cid,
      this.pickup_latitude,
      this.pickup_longitude,
      this.drop_latitude,
      this.drop_longitude,
      this.distance,
      this.modelId,
      this.carMakeId});

  CarMakeFareRequest.fromJson(Map<String, dynamic> json) {
    supervisorId = json['supervisor_id'];
    kioskId = json['kiosk_id'];
    corporateId = json['corporate_id'];
    cid = json['company_id'];
    pickup_latitude = json['pickup_latitude'];
    pickup_longitude = json['pickup_longitude'];
    drop_latitude = json['drop_latitude'];
    drop_longitude = json['drop_longitude'];
    distance = json['distance'];
    modelId = json['model_id'];
    carMakeId = json['car_make_id'];
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
    data['model_id'] = modelId;
    data['car_make_id'] = carMakeId;

    return data;
  }
}

class CarMakeFareResponse {
  String? message;
  int? status;
  CarMakeDetails? carMakeDetails;

  CarMakeFareResponse({this.message, this.carMakeDetails, this.status});

  CarMakeFareResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    carMakeDetails = json['details'] != null
        ? CarMakeDetails.fromJson(json['details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (carMakeDetails != null) {
      data['details'] = carMakeDetails!.toJson();
    }
    return data;
  }
}

class CarMakeDetails {
  CarMakeFareDetails? carMakeFareDetails;

  CarMakeDetails({this.carMakeFareDetails});

  CarMakeDetails.fromJson(Map<String, dynamic> json) {
    carMakeFareDetails = json['carMakeFare'] != null
        ? CarMakeFareDetails.fromJson(json['carMakeFare'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (carMakeFareDetails != null) {
      data['carMakeFare'] = carMakeFareDetails!.toJson();
    }
    return data;
  }
}

class CarMakeFareDetails {
  num? fare;
  num? driverShare;
  num? rslShare;
  num? corporateShare;
  int? zoneFareApplied;
  int? pickupZoneId;
  int? pickupZoneGroupId;
  int? dropZoneId;
  int? dropZoneGroupId;

  CarMakeFareDetails({
    this.fare,
    this.driverShare,
    this.rslShare,
    this.corporateShare,
    this.zoneFareApplied,
    this.pickupZoneId,
    this.pickupZoneGroupId,
    this.dropZoneId,
    this.dropZoneGroupId,
  });

  CarMakeFareDetails.fromJson(Map<String, dynamic> json) {
    fare = json['fare'];
    driverShare = json['driver_share'];
    rslShare = json['rsl_share'];
    corporateShare = json['corporate_share'];
    zoneFareApplied = json['zone_fare_applied'];
    pickupZoneGroupId = json['pickup_zone_group_id'];
    pickupZoneId = json['pickup_zone_id'];
    dropZoneId = json['drop_zone_id'];
    dropZoneGroupId = json['drop_zone_group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fare'] = this.fare;
    data['driver_share'] = driverShare;
    data['rsl_share'] = rslShare;
    data['corporate_share'] = corporateShare;
    data['zone_fare_applied'] = zoneFareApplied;
    data['pickup_zone_group_id'] = pickupZoneGroupId;
    data['pickup_zone_id'] = pickupZoneId;
    data['drop_zone_id'] = dropZoneId;
    data['drop_zone_group_id'] = dropZoneGroupId;
    return data;
  }
}

CarMakeFareResponse carMakeFareResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return CarMakeFareResponse.fromJson(jsonData);
}

String carMakeFareRequestToJson(CarMakeFareRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
