import 'dart:convert';

class GetCoreResponse {
  int? status;
  String? message;
  GetCoreDetails? details;

  GetCoreResponse({
    this.status,
    this.message,
    this.details,
  });

  GetCoreResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    details = json['details'] != null
        ? GetCoreDetails.fromJson(json['details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class GetCoreDetails {
  String? monitorNodeUrl;
  String? referralNodeUrl;
  String? corporateNodeUrl;
  int? supervisorRiderReferral;
  String? videoDate;
  String? imgDate;

  GetCoreDetails({
    this.monitorNodeUrl,
    this.referralNodeUrl,
    this.corporateNodeUrl,
    this.supervisorRiderReferral,
    this.videoDate,
    this.imgDate,
  });

  GetCoreDetails.fromJson(Map<String, dynamic> json) {
    monitorNodeUrl = json['monitor_node_url'];
    referralNodeUrl = json['referral_node_url'];
    corporateNodeUrl=json['corporate_node_url'];
    supervisorRiderReferral = json['supervisor_rider_referral'];
    videoDate = json['video_date'];
    imgDate = json['img_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['monitor_node_url'] = monitorNodeUrl;
    data['referral_node_url'] = referralNodeUrl;
    data['corporate_node_url'] = corporateNodeUrl;
    data['supervisor_rider_referral'] = supervisorRiderReferral;
    data['video_date'] = videoDate;
    data['img_date'] = imgDate;
    return data;
  }
}

GetCoreResponse getCoreApiResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return GetCoreResponse.fromJson(jsonData);
}
