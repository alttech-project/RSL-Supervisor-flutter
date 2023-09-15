import 'dart:convert';


class SubscriberListRequestData {
  String? kioskId;
  String? companyId;

  SubscriberListRequestData({this.kioskId, this.companyId});

  SubscriberListRequestData.fromJson(Map<String, dynamic> json) {
    kioskId = json['kiosk_id'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kiosk_id'] = kioskId;
    data['company_id'] = companyId;
    return data;
  }
}

// class SubscriberListResponseData {
//   String? message;
//   int? status;
//   Details? details;
//   String? authKey;
//
//   SubscriberListResponseData(
//       {this.message, this.status, this.details, this.authKey});
//
//   SubscriberListResponseData.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     status = json['status'];
//     details =
//     json['details'] != null ? new Details.fromJson(json['details']) : null;
//     authKey = json['auth_key'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     data['status'] = this.status;
//     if (this.details != null) {
//       data['details'] = this.details!.toJson();
//     }
//     data['auth_key'] = this.authKey;
//     return data;
//   }
// }
//
// class Details {
//   List<DriverList>? driverList;
//
//   Details({this.driverList});
//
//   Details.fromJson(Map<String, dynamic> json) {
//     if (json['driver_list'] != null) {
//       driverList = <DriverList>[];
//       json['driver_list'].forEach((v) {
//         driverList!.add(new DriverList.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.driverList != null) {
//       data['driver_list'] = this.driverList!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class DriverList {
//   int? driverId;
//   String? driverName;
//   String? driverPhone;
//   String? modelName;
//   String? taxiNo;
//
//   DriverList(
//       {this.driverId,
//         this.driverName,
//         this.driverPhone,
//         this.modelName,
//         this.taxiNo});
//
//   DriverList.fromJson(Map<String, dynamic> json) {
//     driverId = json['driver_id'];
//     driverName = json['driver_name'];
//     driverPhone = json['driver_phone'];
//     modelName = json['model_name'];
//     taxiNo = json['taxi_no'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['driver_id'] = this.driverId;
//     data['driver_name'] = this.driverName;
//     data['driver_phone'] = this.driverPhone;
//     data['model_name'] = this.modelName;
//     data['taxi_no'] = this.taxiNo;
//     return data;
//   }
// }

class SubscriberListResponseData {
  String? message;
  int? status;
  Details? details;
  String? authKey;

  SubscriberListResponseData(
      {this.message, this.status, this.details, this.authKey});

  SubscriberListResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    data['auth_key'] = this.authKey;
    return data;
  }
}

class Details {
  List<DriverList>? driverList;

  Details({this.driverList});

  Details.fromJson(Map<String, dynamic> json) {
    if (json['driver_list'] != null) {
      driverList = <DriverList>[];
      json['driver_list'].forEach((v) {
        driverList!.add(new DriverList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.driverList != null) {
      data['driver_list'] = this.driverList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DriverList {
  int? driverId;
  String? driverName;
  String? driverPhone;
  String? modelName;
  String? taxiNo;

  DriverList(
      {this.driverId,
        this.driverName,
        this.driverPhone,
        this.modelName,
        this.taxiNo});

  DriverList.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    driverName = json['driver_name'];
    driverPhone = json['driver_phone'];
    modelName = json['model_name'];
    taxiNo = json['taxi_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_id'] = this.driverId;
    data['driver_name'] = this.driverName;
    data['driver_phone'] = this.driverPhone;
    data['model_name'] = this.modelName;
    data['taxi_no'] = this.taxiNo;
    return data;
  }
}

SubscriberListResponseData subscriberListResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return SubscriberListResponseData.fromJson(jsonData);
}

String subscriberListRequestToJson(SubscriberListRequestData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}