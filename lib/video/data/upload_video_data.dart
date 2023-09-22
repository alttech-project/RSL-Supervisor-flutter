import 'dart:convert';

class UploadVideoRequest {
  String? pushId;
  String? videoURL;

  UploadVideoRequest({this.pushId, this.videoURL});

  UploadVideoRequest.fromJson(Map<String, dynamic> json) {
    pushId = json['pushId'];
    videoURL = json['videoURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pushId'] = pushId;
    data['videoURL'] = videoURL;
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
