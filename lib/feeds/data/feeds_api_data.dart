import 'dart:convert';
import 'dart:ffi';

class FeedsApiRequest {
  String? id;
  int? pageLimit;
  int? pageNumber;

  FeedsApiRequest({this.id, this.pageLimit, this.pageNumber});

  FeedsApiRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pageLimit = json['pageLimit'];
    pageNumber = json['pageNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pageLimit'] = pageLimit;
    data['pageNumber'] = pageNumber;
    return data;
  }
}

class FeedsApiResponse {
  int? httpCode;
  int? status;
  String? message;
  List<FeedsList>? feedsList;

  FeedsApiResponse({this.httpCode, this.status, this.message, this.feedsList});

  FeedsApiResponse.fromJson(Map<String, dynamic> json) {
    httpCode = json['httpCode'];
    status = json['status'];
    message = json['message'];
    if (json['responseData'] != null) {
      feedsList = <FeedsList>[];
      json['responseData'].forEach((v) {
        feedsList!.add(FeedsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['httpCode'] = httpCode;
    data['status'] = status;
    data['message'] = message;
    if (feedsList != null) {
      data['responseData'] = feedsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedsList {
  String? name;
  String? createdAt;
  String? updatedAt;
  String? videoUrl;
  String? pushId;

  FeedsList(
      {this.name,
      this.createdAt,
      this.updatedAt,
      this.videoUrl,
      this.pushId});

  FeedsList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    videoUrl = json['videoUrl'];
    pushId = json['pushId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['videoUrl'] = videoUrl;
    data['pushId'] = pushId;
    return data;
  }
}

FeedsApiResponse feedsApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return FeedsApiResponse.fromJson(jsonData);
}

String feedsApiRequestToJson(FeedsApiRequest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
