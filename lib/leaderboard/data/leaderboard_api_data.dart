






import 'dart:convert';

class LeaderboardRequestData {
  int? forRange;
  int? supervisorId;
  int? basedOn;

  LeaderboardRequestData({this.forRange, this.supervisorId, this.basedOn});

  LeaderboardRequestData.fromJson(Map<String, dynamic> json) {
    forRange = json['forRange'];
    supervisorId = json['supervisorId'];
    basedOn = json['basedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forRange'] = this.forRange;
    data['supervisorId'] = this.supervisorId;
    data['basedOn'] = this.basedOn;
    return data;
  }
}

class LeaderboardApiResponse {
  int? httpCode;
  int? status;
  String? message;
  List<ResponseDate>? responseDate;

  LeaderboardApiResponse(
      {this.httpCode, this.status, this.message, this.responseDate});

  LeaderboardApiResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
    if (json['responseDate'] != null) {
      responseDate = <ResponseDate>[];
      json['responseDate'].forEach((v) {
        responseDate!.add(new ResponseDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpCode'] = this.httpCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.responseDate != null) {
      data['responseDate'] = this.responseDate!.map((v) => v.toJson()).toList();
    }
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