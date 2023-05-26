import 'dart:convert';

class DashboardRequestData {
  String? userID;

  DashboardRequestData({this.userID});

  DashboardRequestData.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    return data;
  }
}

class DashboardResponseData {
  int? statusCode;
  String? statusMessage;
  ResponseData? responseData;

  DashboardResponseData(
      {this.statusCode, this.statusMessage, this.responseData});

  DashboardResponseData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['statusMessage'] = this.statusMessage;
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.toJson();
    }
    return data;
  }
}

class ResponseData {
  String? itemCounts;
  String? warehouseCount;
  String? countStatus;
  String? countLog;
  String? suppliersCount;

  ResponseData(
      {this.itemCounts,
      this.warehouseCount,
      this.countStatus,
      this.countLog,
      this.suppliersCount});

  ResponseData.fromJson(Map<String, dynamic> json) {
    itemCounts = json['itemCounts'];
    warehouseCount = json['warehouseCount'];
    countStatus = json['countStatus'];
    countLog = json['countLog'];
    suppliersCount = json['suppliersCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemCounts'] = this.itemCounts;
    data['warehouseCount'] = this.warehouseCount;
    data['countStatus'] = this.countStatus;
    data['countLog'] = this.countLog;
    data['suppliersCount'] = this.suppliersCount;
    return data;
  }
}

DashboardResponseData dashboardResponseDataFromJson(String str) {
  final jsonData = json.decode(str);
  return DashboardResponseData.fromJson(jsonData);
}

String dashboardRequestDataToJson(DashboardRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
