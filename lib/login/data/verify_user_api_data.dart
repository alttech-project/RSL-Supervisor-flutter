import 'dart:convert';

class VerifyUserNameRequestData {
  String? companyDomain;
  String? companyMainDomain;
  String? username;
  String? cid;
  String? deviceToken;

  VerifyUserNameRequestData(
      {this.companyDomain,
        this.companyMainDomain,
        this.username,
        this.cid,
        this.deviceToken});

  VerifyUserNameRequestData.fromJson(Map<String, dynamic> json) {
    companyDomain = json['company_domain'];
    companyMainDomain = json['company_main_domain'];
    username = json['username'];
    cid = json['cid'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_domain'] = companyDomain;
    data['company_main_domain'] = companyMainDomain;
    data['username'] = username;
    data['cid'] = cid;
    data['device_token'] = deviceToken;
    return data;
  }
}

class VerifyUserNameResponseData {
  String? message;
  int? status;
  int? otp;
  String? authKey;

  VerifyUserNameResponseData(
      {this.message, this.status, this.otp, this.authKey});

  VerifyUserNameResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    otp = json['otp'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['otp'] = otp;
    data['auth_key'] = authKey;
    return data;
  }
}

VerifyUserNameResponseData verifyUserNameResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return VerifyUserNameResponseData.fromJson(jsonData);
}

String verifyUserNameRequestToJson(VerifyUserNameRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}