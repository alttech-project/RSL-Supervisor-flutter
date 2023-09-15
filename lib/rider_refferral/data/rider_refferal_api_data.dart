




import 'dart:convert';

class RiderReferralRequest {
  int? supervisorId;

  RiderReferralRequest({this.supervisorId});

  RiderReferralRequest.fromJson(Map<String, dynamic> json) {
    supervisorId = json['supervisorId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supervisorId'] = this.supervisorId;
    return data;
  }
}


class RiderRefferalResponseData {
  int? status;
  String? message;
  Details? details;

  RiderRefferalResponseData({this.status, this.message, this.details});

  RiderRefferalResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Details {
  String? referralCode;
  int? referralAmount;
  int? amountEarned;
  int? totalAmountToEarn;
  int? pendingAmount;
  String? referralCodeLink;
  String? description;

  Details(
      {this.referralCode,
        this.referralAmount,
        this.amountEarned,
        this.totalAmountToEarn,
        this.pendingAmount,
        this.referralCodeLink,
        this.description});

  Details.fromJson(Map<String, dynamic> json) {
    referralCode = json['referralCode'];
    referralAmount = json['referralAmount'];
    amountEarned = json['amountEarned'];
    totalAmountToEarn = json['totalAmountToEarn'];
    pendingAmount = json['pendingAmount'];
    referralCodeLink = json['referralCodeLink'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['referralCode'] = this.referralCode;
    data['referralAmount'] = this.referralAmount;
    data['amountEarned'] = this.amountEarned;
    data['totalAmountToEarn'] = this.totalAmountToEarn;
    data['pendingAmount'] = this.pendingAmount;
    data['referralCodeLink'] = this.referralCodeLink;
    data['description'] = this.description;
    return data;
  }
}

class RiderReferraMessageRequestData {
  int? supervisorId;
  String? countryCode;
  String? passengerPhone;

  RiderReferraMessageRequestData(
      {this.supervisorId, this.countryCode, this.passengerPhone});

  RiderReferraMessageRequestData.fromJson(Map<String, dynamic> json) {
    supervisorId = json['supervisorId'];
    countryCode = json['countryCode'];
    passengerPhone = json['passengerPhone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supervisorId'] = this.supervisorId;
    data['countryCode'] = this.countryCode;
    data['passengerPhone'] = this.passengerPhone;
    return data;
  }
}

class RiderReferraMessageResponseData {
  int? status;
  String? message;

  RiderReferraMessageResponseData({this.status, this.message});

  RiderReferraMessageResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class RiderRefferalHistoryRequestData {
  int? supervisorId;

  RiderRefferalHistoryRequestData({this.supervisorId});

  RiderRefferalHistoryRequestData.fromJson(Map<String, dynamic> json) {
    supervisorId = json['supervisorId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supervisorId'] = this.supervisorId;
    return data;
  }
}

class RiderRefferalHistoryResponseData {
  int? status;
  String? message;
  ReferralHistoryDetails? referralHistoryDetails;

  RiderRefferalHistoryResponseData({this.status, this.message, this.referralHistoryDetails});

  RiderRefferalHistoryResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    referralHistoryDetails =
    json['details'] != null ? new ReferralHistoryDetails.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.referralHistoryDetails != null) {
      data['details'] = this.referralHistoryDetails!.toJson();
    }
    return data;
  }
}

class ReferralHistoryDetails {
  String? referralCode;
  int? referralAmount;
  int? amountEarned;
  List<ReferralHistory>? referralHistory;
  String? referralCodeLink;
  String? description;

  ReferralHistoryDetails(
      {this.referralCode,
        this.referralAmount,
        this.amountEarned,
        this.referralHistory,
        this.referralCodeLink,
        this.description});

  ReferralHistoryDetails.fromJson(Map<String, dynamic> json) {
    referralCode = json['referralCode'];
    referralAmount = json['referralAmount'];
    amountEarned = json['amountEarned'];
    if (json['referralHistory'] != null) {
      referralHistory = <ReferralHistory>[];
      json['referralHistory'].forEach((v) {
        referralHistory!.add(new ReferralHistory.fromJson(v));
      });
    }
    referralCodeLink = json['referralCodeLink'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['referralCode'] = this.referralCode;
    data['referralAmount'] = this.referralAmount;
    data['amountEarned'] = this.amountEarned;
    if (this.referralHistory != null) {
      data['referralHistory'] =
          this.referralHistory!.map((v) => v.toJson()).toList();
    }
    data['referralCodeLink'] = this.referralCodeLink;
    data['description'] = this.description;
    return data;
  }
}

class ReferralHistory {
  int? passengerId;
  String? phone;
  String? name;
  String? lastName;
  int? referralAmountUsed;
  int? earnedAmount;
  String? referralDescription;

  ReferralHistory(
      {this.passengerId,
        this.phone,
        this.name,
        this.lastName,
        this.referralAmountUsed,
        this.earnedAmount,
        this.referralDescription});

  ReferralHistory.fromJson(Map<String, dynamic> json) {
    passengerId = json['passengerId'];
    phone = json['phone'];
    name = json['name'];
    lastName = json['LastName'];
    referralAmountUsed = json['referralAmountUsed'];
    earnedAmount = json['earnedAmount'];
    referralDescription = json['referralDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['passengerId'] = this.passengerId;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['LastName'] = this.lastName;
    data['referralAmountUsed'] = this.referralAmountUsed;
    data['earnedAmount'] = this.earnedAmount;
    data['referralDescription'] = this.referralDescription;
    return data;
  }
}





RiderReferraMessageResponseData RiderRefferalMsgFromJson(String str) {
  final jsonData = json.decode(str);
  return RiderReferraMessageResponseData.fromJson(jsonData);
}

String riderReferralMsgRequestToJson(RiderReferraMessageRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}


RiderRefferalResponseData RiderRefferalFromJson(String str) {
  final jsonData = json.decode(str);
  return RiderRefferalResponseData.fromJson(jsonData);
}

String riderReferralRequestToJson(RiderReferralRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}


RiderRefferalHistoryResponseData RiderRefferalHistoryFromJson(String str) {
  final jsonData = json.decode(str);
  return RiderRefferalHistoryResponseData.fromJson(jsonData);
}

String riderReferralHistoryRequestToJson(RiderRefferalHistoryRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}