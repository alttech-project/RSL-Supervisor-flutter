import 'dart:convert';

class GetPlacesResponse {
  List<Predictions>? predictions;
  String? status;

  GetPlacesResponse({this.predictions, this.status});

  GetPlacesResponse.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      predictions = <Predictions>[];
      json['predictions'].forEach((v) {
        predictions!.add(Predictions.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (predictions != null) {
      data['predictions'] = predictions!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Predictions {
  String? description;
  String? placeId;

  Predictions({this.description, this.placeId});

  Predictions.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    placeId = json['place_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['place_id'] = placeId;
    return data;
  }
}

GetPlacesResponse getPlacesFromJson(String str) {
  final jsonData = json.decode(str);
  return GetPlacesResponse.fromJson(jsonData);
}
