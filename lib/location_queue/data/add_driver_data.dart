import 'dart:convert';

class AddDriverRequest {
  int? driverId;
  String? kioskId;
  int? modelId;
  String? requestType;
  String? cid;

  AddDriverRequest(
      {this.driverId, this.kioskId, this.modelId, this.requestType, this.cid});

  AddDriverRequest.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    kioskId = json['kiosk_id'];
    modelId = json['model_id'];
    requestType = json['request_type'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver_id'] = driverId;
    data['kiosk_id'] = kioskId;
    data['model_id'] = modelId;
    data['request_type'] = requestType;
    data['cid'] = cid;
    return data;
  }
}

class AddDriverResponse {
  String? message;
  int? driverPosition;
  int? queueLimit;
  int? status;
  int? driverInMainQueue;
  String? kioskId;
  int? modelId;
  String? authKey;

  AddDriverResponse(
      {this.message,
      this.driverPosition,
      this.queueLimit,
      this.status,
      this.driverInMainQueue,
      this.kioskId,
      this.modelId,
      this.authKey});

  AddDriverResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    driverPosition = json['driver_position'];
    queueLimit = json['queue_limit'];
    status = json['status'];
    driverInMainQueue = json['driverInMainQueue'];
    kioskId = json['kiosk_id'];
    modelId = json['model_id'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['driver_position'] = driverPosition;
    data['queue_limit'] = queueLimit;
    data['status'] = status;
    data['driverInMainQueue'] = driverInMainQueue;
    data['kiosk_id'] = kioskId;
    data['model_id'] = modelId;
    data['auth_key'] = authKey;
    return data;
  }
}

AddDriverResponse addDriverResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return AddDriverResponse.fromJson(jsonData);
}

String addDriverRequestToJson(AddDriverRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
