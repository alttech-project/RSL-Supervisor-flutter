













import 'dart:convert';


class TripHistoryMapRequestedData {
  int? tripId;
  String? cid;

  TripHistoryMapRequestedData({this.tripId, this.cid});

  TripHistoryMapRequestedData.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    cid = json['cid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trip_id'] = this.tripId;
    data['cid'] = this.cid;
    return data;
  }
}


class TripHistoryMapResponseData {
  String? message;
  int? status;
  Detail? detail;
  String? authKey;

  TripHistoryMapResponseData(
      {this.message, this.status, this.detail, this.authKey});

  TripHistoryMapResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    detail =
    json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
    authKey = json['auth_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.detail != null) {
      data['detail'] = this.detail!.toJson();
    }
    data['auth_key'] = this.authKey;
    return data;
  }
}

class Detail {
  List<MapDatas>? mapDatas;

  Detail({this.mapDatas});

  Detail.fromJson(Map<String, dynamic> json) {
    if (json['map_datas'] != null) {
      mapDatas = <MapDatas>[];
      json['map_datas'].forEach((v) {
        mapDatas!.add(new MapDatas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mapDatas != null) {
      data['map_datas'] = this.mapDatas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MapDatas {
  double? latitude;
  double? longitude;

  MapDatas({this.latitude, this.longitude});

  MapDatas.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

String tripHistoryMapRequestToJson(TripHistoryMapRequestedData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

TripHistoryMapResponseData tripHistoryMapResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return TripHistoryMapResponseData.fromJson(jsonData);
}
