import 'dart:convert';

import 'driver_list_data.dart';

class SearchDriverResponse {
  String? message;
  List<DriverDetails>? details;
  int? status;
  String? authKey;

  SearchDriverResponse({
    this.message,
    this.details,
    this.status,
    this.authKey,
  });

  SearchDriverResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['details'] != null) {
      details = <DriverDetails>[];
      json['details'].forEach((v) {
        details!.add(DriverDetails.fromJson(v));
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

class SearchDriverRequest {
  String? keyword;
  String? kioskId;
  String? cid;

  SearchDriverRequest({this.keyword, this.kioskId, this.cid});

  SearchDriverRequest.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    kioskId = json['kiosk_id'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keyword'] = keyword;
    data['kiosk_id'] = kioskId;
    data['cid'] = cid;
    return data;
  }
}

String driverSearchRequestToJson(SearchDriverRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

SearchDriverResponse searchDriverResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return SearchDriverResponse.fromJson(jsonData);
}
