import 'dart:convert';

class UploadVideoRequest {
  String? pushId;
  String? videoURL;
  int? type;

  UploadVideoRequest({this.pushId, this.videoURL, this.type});

  UploadVideoRequest.fromJson(Map<String, dynamic> json) {
    pushId = json['pushId'];
    videoURL = json['videoURL'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pushId'] = pushId;
    data['videoURL'] = videoURL;
    data['type'] = type;
    return data;
  }
}

class UploadVideoResponse {
  String? message;
  int? status;

  UploadVideoResponse({this.message, this.status});

  UploadVideoResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

UploadVideoResponse uploadVideoResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return UploadVideoResponse.fromJson(jsonData);
}

String uploadVideoRequestToJson(UploadVideoRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
