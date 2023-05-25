class VerifyPhoneApiRequestData {
  String? countryCode;
  String? deviceId;
  String? deviceToken;
  String? deviceType;
  String? facebookId;
  String? lang;
  double? latitude;
  double? longitude;
  String? phone;
  List<String>? usedPhone;
  int? verifyType;

  VerifyPhoneApiRequestData(
      {this.countryCode,
      this.deviceId,
      this.deviceToken,
      this.deviceType,
      this.facebookId,
      this.lang,
      this.latitude,
      this.longitude,
      this.phone,
      this.usedPhone,
      this.verifyType});

  VerifyPhoneApiRequestData.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    deviceId = json['device_id'];
    deviceToken = json['device_token'];
    deviceType = json['device_type'];
    facebookId = json['facebook_id'];
    lang = json['lang'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
    if (json['used_phone'] != null) {
      usedPhone = <String>[];
      json['used_phone'].forEach((v) {
        usedPhone!.add(v);
      });
    }
    verifyType = json['verify_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_code'] = countryCode;
    data['device_id'] = deviceId;
    data['device_token'] = deviceToken;
    data['device_type'] = deviceType;
    data['facebook_id'] = facebookId;
    data['lang'] = lang;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phone'] = phone;
    if (usedPhone != null) {
      data['used_phone'] = usedPhone!.map((v) => v).toList();
    }
    data['verify_type'] = verifyType;
    return data;
  }
}

class VerifyPhoneApiResponseData {
  int? status;
  String? message;
  String? address;

  VerifyPhoneApiResponseData({this.status, this.message, this.address});

  VerifyPhoneApiResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['address'] = address;
    return data;
  }
}
