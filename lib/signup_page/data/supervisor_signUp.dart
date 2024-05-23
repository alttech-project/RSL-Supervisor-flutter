import 'dart:convert';

class SignUpApiRequestedData {
  String? name;
  String? email;
  String? phone;
  String? uniqueId;

  SignUpApiRequestedData({this.name, this.email, this.phone, this.uniqueId});

  SignUpApiRequestedData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uniqueId = json['unique_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['unique_id'] = this.uniqueId;
    return data;
  }
}
class SignUpApiResponseData {
  String? message;
  int? status;
  String? authKey;

  SignUpApiResponseData({this.message, this.status, this.authKey});

  SignUpApiResponseData.fromJson(Map<String, dynamic> json) {
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

SignUpApiResponseData signUpApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return SignUpApiResponseData.fromJson(jsonData);
}

String signUpApiRequestToJson(SignUpApiRequestedData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
