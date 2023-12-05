import 'dart:convert';

class LeaderboardRequestData {
  int? forRange;
  int? supervisorId;
  int? locationId;

  LeaderboardRequestData({this.forRange, this.supervisorId, this.locationId});

  LeaderboardRequestData.fromJson(Map<String, dynamic> json) {
    forRange = json['forRange'];
    supervisorId = json['supervisorId'];
    locationId = json['locationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forRange'] = this.forRange;
    data['supervisorId'] = this.supervisorId;
    data['locationId'] = this.locationId;
    return data;
  }
}

class LeaderboardApiResponse {
  int? httpCode;
  int? status;
  String? message;
  LeaderBoardData? responseData;

  LeaderboardApiResponse(
      {this.httpCode, this.status, this.message, this.responseData});

  LeaderboardApiResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
    responseData = json['responseData'] != null
        ? LeaderBoardData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpCode'] = this.httpCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (responseData != null) {
      data['responseData'] = responseData!.toJson();
    }
    return data;
  }
}

class LeaderBoardData {
  String? name;
  String? uniqueId;
  int? dispatchTrips;
  int? target;

  LeaderBoardData({
    this.name,
    this.uniqueId,
    this.dispatchTrips,
    this.target,
  });

  LeaderBoardData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uniqueId = json['uniqueId'];
    dispatchTrips = json['dispatchTrips'];
    target = json['target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['uniqueId'] = uniqueId;
    data['dispatchTrips'] = dispatchTrips;
    data['target'] = target;
    return data;
  }
}

class ResponseDate {
  int? iId;
  int? completedTrips;
  String? amount;
  String? supervisorName;
  int? totalTargetTrips;
  String? targetCompletedPercentage;
  int? points;

  ResponseDate(
      {this.iId,
      this.completedTrips,
      this.amount,
      this.supervisorName,
      this.totalTargetTrips,
      this.targetCompletedPercentage,
      this.points});

  ResponseDate.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    completedTrips = json['completedTrips'];
    amount = json['amount'];
    supervisorName = json['supervisorName'];
    totalTargetTrips = json['totalTargetTrips'];
    targetCompletedPercentage = json['targetCompletedPercentage'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['completedTrips'] = this.completedTrips;
    data['amount'] = this.amount;
    data['supervisorName'] = this.supervisorName;
    data['totalTargetTrips'] = this.totalTargetTrips;
    data['targetCompletedPercentage'] = this.targetCompletedPercentage;
    data['points'] = this.points;
    return data;
  }
}

LeaderboardApiResponse leaderboardApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return LeaderboardApiResponse.fromJson(jsonData);
}

String leaderboardApiRequestToJson(LeaderboardRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
