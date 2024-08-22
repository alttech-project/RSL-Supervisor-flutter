import 'dart:convert';

class AllCarMakeListApiRequest {
  String? cid;

  AllCarMakeListApiRequest({
    this.cid,
  });

  AllCarMakeListApiRequest.fromJson(Map<String, dynamic> json) {
    cid = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_id'] = cid;
    return data;
  }
}

class AllCarMakeListApiResponse {
  int? httpCode;
  int? status;
  String? message;
  CarMakeDetails? carMakeDetails;

  AllCarMakeListApiResponse(
      {this.httpCode, this.status, this.message, this.carMakeDetails});

  AllCarMakeListApiResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
    carMakeDetails = json['details'] != null
        ? CarMakeDetails.fromJson(json['details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['httpCode'] = httpCode;
    data['status'] = status;
    data['message'] = message;
    if (carMakeDetails != null) {
      data['details'] = carMakeDetails!.toJson();
    }
    return data;
  }
}

class CarMakeDetails {
  List<CarMakeList>? carMakeList;

  CarMakeDetails({this.carMakeList});

  CarMakeDetails.fromJson(Map<String, dynamic> json) {
    if (json['taxiMakeList'] != null) {
      carMakeList = <CarMakeList>[];
      json['taxiMakeList'].forEach((v) {
        carMakeList!.add(CarMakeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (carMakeList != null) {
      data['taxiMakeList'] = carMakeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarMakeList {
  int? car_make_id;
  String? car_make_name;
  int? model_id;
  String? model_name;
  num? min_fare;
  num? cancellation_fare;
  String? beforeSelect;
  String? afterSelect;

  CarMakeList(
      {this.car_make_id,
        this.car_make_name,
        this.model_id,
        this.model_name,
        this.min_fare,
        this.cancellation_fare,
        this.beforeSelect,
        this.afterSelect});

  CarMakeList.fromJson(Map<String, dynamic> json) {
    car_make_id = json['car_make_id'];
    car_make_name = json['car_make_name'];
    model_id = json['model_id'];
    model_name = json['model_name'];
    min_fare = json['min_fare'];
    cancellation_fare = json['cancellation_fare'];
    beforeSelect = json['beforeSelect'];
    afterSelect = json['afterSelect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['car_make_id'] = car_make_id;
    data['car_make_name'] = car_make_name;
    data['model_id'] = model_id;
    data['model_name'] = model_name;
    data['min_fare'] = min_fare;
    data['cancellation_fare'] = cancellation_fare;
    data['beforeSelect'] = beforeSelect;
    data['afterSelect'] = afterSelect;
    return data;
  }
}

AllCarMakeListApiResponse allCarMakeListApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return AllCarMakeListApiResponse.fromJson(jsonData);
}

String carMakeRequestToJson(AllCarMakeListApiRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
