import 'dart:convert';

class DriverListRequest {
  String? locationId;

  DriverListRequest({this.locationId});

  DriverListRequest.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_id'] = locationId;
    return data;
  }
}

class DriverListResponse {
  int? status;
  String? message;
  List<DriverList>? driverList;

  DriverListResponse({this.status, this.message, this.driverList});

  DriverListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['details'] != null) {
      driverList = <DriverList>[];
      json['details'].forEach((v) {
        driverList!.add(DriverList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (driverList != null) {
      data['details'] = driverList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DriverList {
  int? driverId;
  String? driverName;
  int? companyId;
  String? driverStatus;
  String? modelId;
  String? modelName;
  String? taxiNo;
  String? driverPhone;

  DriverList(
      {this.driverId,
      this.driverName,
      this.companyId,
      this.driverStatus,
      this.modelId,
      this.modelName,
      this.taxiNo,
      this.driverPhone});

  DriverList.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    driverName = json['driver_name'];
    companyId = json['company_id'];
    driverStatus = json['driver_status'];
    modelId = json['model_id'];
    modelName = json['model_name'];
    taxiNo = json['taxi_no'];
    driverPhone = json['driver_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver_id'] = driverId;
    data['driver_name'] = driverName;
    data['company_id'] = companyId;
    data['driver_status'] = driverStatus;
    data['model_id'] = modelId;
    data['model_name'] = modelName;
    data['taxi_no'] = taxiNo;
    data['driver_phone'] = driverPhone;
    return data;
  }
}

DriverListResponse driverListApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return DriverListResponse.fromJson(jsonData);
}

String driverListApiRequestToJson(DriverListRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
