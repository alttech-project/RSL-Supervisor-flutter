import 'dart:convert';

class DriverQueuePositionRequest {
  String? kioskId;
  int? driverId;
  int? modelId;
  String? cid;

  DriverQueuePositionRequest(
      {this.kioskId, this.driverId, this.modelId, this.cid});

  DriverQueuePositionRequest.fromJson(Map<String, dynamic> json) {
    kioskId = json['kiosk_id'];
    driverId = json['driver_id'];
    modelId = json['model_id'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kiosk_id'] = kioskId;
    data['driver_id'] = driverId;
    data['model_id'] = modelId;
    data['cid'] = cid;
    return data;
  }
}

class DriverQueuePositionResponse {
  String? message;
  int? status;
  String? authKey;

  DriverQueuePositionResponse({this.message, this.status, this.authKey});

  DriverQueuePositionResponse.fromJson(Map<String, dynamic> json) {
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

DriverQueuePositionResponse driverQueuePositionResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return DriverQueuePositionResponse.fromJson(jsonData);
}

String driverQueuePositionRequestToJson(DriverQueuePositionRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
