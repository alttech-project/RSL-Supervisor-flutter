import 'dart:convert';

class TaxiListRequestData {
  String? kioskId;
  String? cid;

  TaxiListRequestData({this.kioskId, this.cid});

  TaxiListRequestData.fromJson(Map<String, dynamic> json) {
    kioskId = json['kiosk_id'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kiosk_id'] = kioskId;
    data['cid'] = cid;
    return data;
  }
}

class TaxiListResponseData {
  String? message;
  List<TaxiDetails>? details;
  int? status;
  String? authKey;

  TaxiListResponseData({this.message, this.details, this.status, this.authKey});

  TaxiListResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['details'] != null) {
      details = <TaxiDetails>[];
      json['details'].forEach((v) {
        details!.add(new TaxiDetails.fromJson(v));
      });
    }
    status = json['status'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['auth_key'] = authKey;
    return data;
  }
}

class TaxiDetails {
  int? iId;
  String? taxiNo;
  int? taxiModel;

  TaxiDetails({this.iId, this.taxiNo, this.taxiModel});

  TaxiDetails.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    taxiNo = json['taxi_no'];
    taxiModel = json['taxi_model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = iId;
    data['taxi_no'] = taxiNo;
    data['taxi_model'] = taxiModel;
    return data;
  }
}

TaxiListResponseData taxiListResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return TaxiListResponseData.fromJson(jsonData);
}

String taxiListRequestToJson(TaxiListRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
