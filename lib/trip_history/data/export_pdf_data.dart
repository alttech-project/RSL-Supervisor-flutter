import 'dart:convert';

class ExportPdfRequest {
  String? driverId;
  String? from;
  String? to;
  String? kioskId;
  String? tripId;
  String? cid;

  ExportPdfRequest({
    this.driverId,
    this.from,
    this.to,
    this.kioskId,
    this.tripId,
    this.cid,
  });

  ExportPdfRequest.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    from = json['from'];
    to = json['to'];
    kioskId = json['kiosk_id'];
    tripId = json['trip_id'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver_id'] = driverId;
    data['from'] = from;
    data['to'] = to;
    data['kiosk_id'] = kioskId;
    data['trip_id'] = tripId;
    data['cid'] = cid;
    return data;
  }
}

class ExportPdfResponse {
  String? message;
  int? status;
  String? authKey;

  ExportPdfResponse({
    this.message,
    this.status,
    this.authKey,
  });

  ExportPdfResponse.fromJson(Map<String, dynamic> json) {
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

String exportPdfRequestToJson(ExportPdfRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

ExportPdfResponse exportPdfResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return ExportPdfResponse.fromJson(jsonData);
}
