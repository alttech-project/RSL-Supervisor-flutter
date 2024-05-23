import 'dart:convert';

class DeactivateAccountRequestedData {
  String? supervisorId;
  String? reason;

  DeactivateAccountRequestedData({this.supervisorId, this.reason});

  DeactivateAccountRequestedData.fromJson(Map<String, dynamic> json) {
    supervisorId = json['supervisor_id'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supervisor_id'] = this.supervisorId;
    data['reason'] = this.reason;
    return data;
  }
}


class DeactivateAccountResponseData {
  String? message;
  int? status;
  String? authKey;

  DeactivateAccountResponseData({this.message, this.status, this.authKey});

  DeactivateAccountResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['auth_key'] = this.authKey;
    return data;
  }
}


DeactivateAccountResponseData deActivateApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return DeactivateAccountResponseData.fromJson(jsonData);
}

String deActivateApiRequestToJson(DeactivateAccountRequestedData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
