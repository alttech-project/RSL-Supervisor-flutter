
import 'dart:convert';

class CarModelTypeRequestData {
  String? kioskId;
  String? supervisorId;
  String? dropLatitude;
  String? dropLongitude;
  String? cid;
  String? deviceToken;

  CarModelTypeRequestData(
      {this.kioskId,
        this.supervisorId,
        this.dropLatitude,
        this.dropLongitude,
        this.cid,
        this.deviceToken});

  CarModelTypeRequestData.fromJson(Map<String, dynamic> json) {
    kioskId = json['kiosk_id'];
    supervisorId = json['supervisor_id'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    cid = json['cid'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kiosk_id'] = this.kioskId;
    data['supervisor_id'] = this.supervisorId;
    data['drop_latitude'] = this.dropLatitude;
    data['drop_longitude'] = this.dropLongitude;
    data['cid'] = this.cid;
    data['device_token'] = this.deviceToken;
    return data;
  }
}


class CarModelTypeResponseData {
  String? message;
  int? status;
  List<CarmodelList>? carmodelList;
  String? authKey;

  CarModelTypeResponseData(
      {this.message, this.status, this.carmodelList, this.authKey});

  CarModelTypeResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['carmodel_list'] != null) {
      carmodelList = <CarmodelList>[];
      json['carmodel_list'].forEach((v) {
        carmodelList!.add(new CarmodelList.fromJson(v));
      });
    }
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.carmodelList != null) {
      data['carmodel_list'] =
          this.carmodelList!.map((v) => v.toJson()).toList();
    }
    data['auth_key'] = this.authKey;
    return data;
  }
}

class CarmodelList {
  int? motorId;
  String? motorName;
  int? priority;
  String? approxFare;
  String? meterFare;
  String? queueName;
  String? fareSetting;
  int? corporateId;
  String? androidFocusModelImage;
  String? modelImage;
  String? androidUnfocusModelImage;
  int? driverCount;

  CarmodelList(
      {this.motorId,
        this.motorName,
        this.priority,
        this.approxFare,
        this.meterFare,
        this.queueName,
        this.fareSetting,
        this.corporateId,
        this.androidFocusModelImage,
        this.modelImage,
        this.androidUnfocusModelImage,
        this.driverCount});

  CarmodelList.fromJson(Map<String, dynamic> json) {
    motorId = json['motor_id'];
    motorName = json['motor_name'];
    priority = json['priority'];
    approxFare = json['approx_fare'];
    meterFare = json['meter_fare'];
    queueName = json['queue_name'];
    fareSetting = json['fare_setting'];
    corporateId = json['corporate_id'];
    androidFocusModelImage = json['android_focus_model_image'];
    modelImage = json['model_image'];
    androidUnfocusModelImage = json['android_unfocus_model_image'];
    driverCount = json['driver_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['motor_id'] = this.motorId;
    data['motor_name'] = this.motorName;
    data['priority'] = this.priority;
    data['approx_fare'] = this.approxFare;
    data['meter_fare'] = this.meterFare;
    data['queue_name'] = this.queueName;
    data['fare_setting'] = this.fareSetting;
    data['corporate_id'] = this.corporateId;
    data['android_focus_model_image'] = this.androidFocusModelImage;
    data['model_image'] = this.modelImage;
    data['android_unfocus_model_image'] = this.androidUnfocusModelImage;
    data['driver_count'] = this.driverCount;
    return data;
  }
}



CarModelTypeResponseData carModelApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return CarModelTypeResponseData.fromJson(jsonData);
}


String carModelApiRequestToJson(CarModelTypeRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}