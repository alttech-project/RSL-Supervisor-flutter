import 'dart:convert';

class ShiftInRequest {
  String? kioskId;
  String? supervisorId;
  String? cid;
  String? type;

  ShiftInRequest({this.kioskId, this.supervisorId, this.cid, this.type});

  ShiftInRequest.fromJson(Map<String, dynamic> json) {
    kioskId = json['kiosk_id'];
    supervisorId = json['supervisor_id'];
    cid = json['cid'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kiosk_id'] = kioskId;
    data['supervisor_id'] = supervisorId;
    data['cid'] = cid;
    data['type'] = type;
    return data;
  }
}

class ShiftInResponse {
  int? httpCode;
  int? status;
  String? message;

  ShiftInResponse({this.httpCode, this.status, this.message});

  ShiftInResponse.fromJson(Map<String, dynamic> json) {
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

ShiftInResponse shiftInApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return ShiftInResponse.fromJson(jsonData);
}

String shiftInApiRequestToJson(ShiftInRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
