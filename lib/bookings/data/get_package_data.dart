import 'dart:convert';

class GetCorporatePackageListRequest {
  int? corporateId;
  int? modelId;
  int? packageType;
  int? car_make_id;

  GetCorporatePackageListRequest({
    this.corporateId,
    this.modelId,
    this.packageType,
    this.car_make_id,
  });

  GetCorporatePackageListRequest.fromJson(Map<String, dynamic> json) {
    corporateId = json['corporate_id'];
    modelId = json['model_id'];
    packageType = json['package_type'];
    car_make_id = json['car_make_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['corporate_id'] = corporateId;
    data['model_id'] = modelId;
    data['package_type'] = packageType;
    data['car_make_id'] = car_make_id;
    return data;
  }
}

class CorporatePackageListApiResponse {
  int? httpCode;
  int? status;
  String? message;
  PackageDetails? packageDetails;

  CorporatePackageListApiResponse(
      {this.httpCode, this.status, this.message, this.packageDetails});

  CorporatePackageListApiResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
    packageDetails = json['details'] != null
        ? PackageDetails.fromJson(json['details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['httpCode'] = httpCode;
    data['status'] = status;
    data['message'] = message;
    if (packageDetails != null) {
      data['details'] = packageDetails!.toJson();
    }
    return data;
  }
}

class PackageDetails {
  List<CorporatePackageList>? packageList;

  PackageDetails({this.packageList});

  PackageDetails.fromJson(Map<String, dynamic> json) {
    if (json['packageList'] != null) {
      packageList = <CorporatePackageList>[];
      json['packageList'].forEach((v) {
        packageList!.add(CorporatePackageList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (packageList != null) {
      data['packageList'] = packageList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CorporatePackageList {
  int? id;
  num? amount;
  num? km;
  num? duration;
  int? type;
  String? currency;
  String? typeLabel;

  CorporatePackageList(
      {this.id,
      this.amount,
      this.km,
      this.duration,
      this.type,
      this.currency,
      this.typeLabel});

  CorporatePackageList.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    amount = json['amount'];
    km = json['km'];
    duration = json['duration'];
    type = json['type'];
    currency = json['currency'];
    typeLabel = json['typeLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['amount'] = amount;
    data['km'] = km;
    data['duration'] = duration;
    data['type'] = type;
    data['currency'] = currency;
    data['typeLabel'] = typeLabel;

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
