import 'dart:convert';

class DriverListRequest {
  String? kioskId;
  String? supervisorId;
  String? cid;

  DriverListRequest({this.kioskId, this.supervisorId, this.cid});

  DriverListRequest.fromJson(Map<String, dynamic> json) {
    kioskId = json['kiosk_id'];
    supervisorId = json['supervisor_id'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kiosk_id'] = kioskId;
    data['supervisor_id'] = supervisorId;
    data['cid'] = cid;
    return data;
  }
}

class DriverListResponse {
  String? message;
  DriverList? driverList;
  int? status;
  String? authKey;

  DriverListResponse(
      {this.message, this.driverList, this.status, this.authKey});

  DriverListResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    driverList = json['driver_list'] != null
        ? DriverList.fromJson(json['driver_list'])
        : null;
    status = json['status'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (driverList != null) {
      data['driver_list'] = driverList!.toJson();
    }
    data['status'] = status;
    data['auth_key'] = authKey;
    return data;
  }
}

class DriverList {
  List<DriverDetails>? mainDriverDetails;
  List<DriverDetails>? waitingDriverDetails;
  List<DriverDetails>? outWaitingDriverDetails;


  DriverList({this.mainDriverDetails, this.waitingDriverDetails});

  DriverList.fromJson(Map<String, dynamic> json) {
    if (json['main_driver_details'] != null) {
      mainDriverDetails = <DriverDetails>[];
      json['main_driver_details'].forEach((v) {
        mainDriverDetails!.add(DriverDetails.fromJson(v));
      });
    }
    if (json['secondary_driver_details'] != null) {
      waitingDriverDetails = <DriverDetails>[];
      json['secondary_driver_details'].forEach((v) {
        waitingDriverDetails!.add(DriverDetails.fromJson(v));
      });
    }
    if (json['waiting_driver_details'] != null) {
      outWaitingDriverDetails = <DriverDetails>[];
      json['waiting_driver_details'].forEach((v) {
        outWaitingDriverDetails!.add(DriverDetails.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainDriverDetails != null) {
      data['main_driver_details'] =
          mainDriverDetails!.map((v) => v.toJson()).toList();
    }
    if (waitingDriverDetails != null) {
      data['secondary_driver_details'] =
          waitingDriverDetails!.map((v) => v.toJson()).toList();
    }
    if (outWaitingDriverDetails != null) {
      data['waiting_driver_details'] =
          outWaitingDriverDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DriverDetails {
  int? id;
  int? modelId;
  String? modelName;
  String? driverName;
  int? driverId;
  String? pickupLocation;
  String? queueName;
  String? carRslNo;
  String? taxiNo;
  String? driverRslNo;
  String? driverRsl;
  String? currentTripId;
  String? entryTime;
  String? updatedTime;
  String? totalDuration;
  String? label;

  DriverDetails({
    this.id,
    this.modelId,
    this.modelName,
    this.driverName,
    this.driverId,
    this.pickupLocation,
    this.queueName,
    this.carRslNo,
    this.taxiNo,
    this.driverRslNo,
    this.driverRsl,
    this.currentTripId,
    this.entryTime,
    this.updatedTime,
    this.totalDuration,
    this.label,
  });

  DriverDetails.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    modelId = json['model_id'];
    modelName = json['model_name'];
    driverName = json['driver_name'];
    driverId = json['driver_id'];
    pickupLocation = json['pickup_location'];
    queueName = json['queue_name'];
    carRslNo = json['car_rsl_no'];
    taxiNo = json['taxi_no'];
    driverRslNo = json['driver_rsl_no'];
    driverRsl = json['driver_rsl'];
    currentTripId = json['current_trip_id'];
    entryTime = json['entry_time'];
    updatedTime = json['date_time'];
    totalDuration = json['updated_date_time'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['model_id'] = modelId;
    data['model_name'] = modelName;
    data['driver_name'] = driverName;
    data['driver_id'] = driverId;
    data['pickup_location'] = pickupLocation;
    data['queue_name'] = queueName;
    data['car_rsl_no'] = carRslNo;
    data['taxi_no'] = taxiNo;
    data['driver_rsl_no'] = driverRslNo;
    data['driver_rsl'] = driverRsl;
    data['current_trip_id'] = currentTripId;
    data['date_time'] = updatedTime;
    data['entry_time'] = entryTime;
    data['label'] = label;
    data['updated_date_time'] = updatedTime;

    return data;
  }
}

class UpdateDriverListResponse {
  String? message;
  List<DriverDetails>? driverList;
  int? status;
  String? authKey;

  UpdateDriverListResponse({
    this.message,
    this.driverList,
    this.status,
    this.authKey,
  });

  UpdateDriverListResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['driver_list'] != null) {
      driverList = <DriverDetails>[];
      json['driver_list'].forEach((v) {
        driverList!.add(DriverDetails.fromJson(v));
      });
    }
    status = json['status'];
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (driverList != null) {
      data['driver_list'] = driverList!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['auth_key'] = authKey;
    return data;
  }
}

UpdateDriverListResponse updateDriverListApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return UpdateDriverListResponse.fromJson(jsonData);
}

DriverListResponse driverListApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return DriverListResponse.fromJson(jsonData);
}

String driverListApiRequestToJson(DriverListRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class UpdateDriverQueueRequest {
  List<int>? driverArray;
  List<int>? secondaryDriverArray;
  String? kioskId;
  String? cid;
  int? type;
  String? driverID;
  int? queueType;
  int? positionIndex;





  UpdateDriverQueueRequest(
      {this.driverArray, this.secondaryDriverArray, this.kioskId, this.cid,this.driverID,this.type,this.queueType,this.positionIndex});

  UpdateDriverQueueRequest.fromJson(Map<String, dynamic> json) {
    driverArray = json['driverArray'].cast<int>();
    secondaryDriverArray = json['secondaryDriverArray'].cast<int>();
    kioskId = json['kiosk_id'];
    cid = json['cid'];
    type = json['type'];
    queueType = json['queue_type'];
    positionIndex = json['position_in_index'];



  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverArray'] = driverArray;
    data['secondaryDriverArray'] = secondaryDriverArray;
    data['kiosk_id'] = kioskId;
    data['cid'] = cid;
    data['type'] = type;
    data['driver_id'] = driverID;
    data['position_in_index'] = positionIndex;
    data['queue_type'] = queueType;



    return data;
  }
}

String updateDriverQueueRequestToJson(UpdateDriverQueueRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
