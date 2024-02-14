import 'dart:convert';

class GetCorporatePackageListRequest {
  int? corporateId;
  int? modelId;
  int? packageType;

  GetCorporatePackageListRequest(
      {this.corporateId, this.modelId, this.packageType});

  GetCorporatePackageListRequest.fromJson(Map<String, dynamic> json) {
    corporateId = json['corporate_id'];
    modelId = json['model_id'];
    packageType = json['package_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['corporate_id'] = corporateId;
    data['model_id'] = modelId;
    data['package_type'] = packageType;
    return data;
  }
}

class CorporatePackageListApiResponse {
  int? httpCode;
  int? status;
  String? message;
  List<CorporatePackageList>? packageList;

  CorporatePackageListApiResponse(
      {this.httpCode, this.status, this.message, this.packageList});

  CorporatePackageListApiResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
    if (json['responseData'] != null) {
      packageList = <CorporatePackageList>[];
      json['responseData'].forEach((v) {
        packageList!.add(CorporatePackageList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['httpCode'] = httpCode;
    data['status'] = status;
    data['message'] = message;
    if (packageList != null) {
      data['responseData'] = packageList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CorporatePackageList {
  int? id;
  String? name;

  CorporatePackageList({this.id, this.name});

  CorporatePackageList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

CorporatePackageListApiResponse corporatePackageListApiResponseFromJson(
    String str) {
  final jsonData = json.decode(str);
  return CorporatePackageListApiResponse.fromJson(jsonData);
}

String corporatePackageListApiRequestToJson(
    GetCorporatePackageListRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
