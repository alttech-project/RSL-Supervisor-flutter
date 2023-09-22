import 'package:get/get.dart';
import 'package:rsl_supervisor/network/app_config.dart';
import 'package:rsl_supervisor/rider_refferral/data/rider_referral_api_data.dart';

import '../../network/services.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<RiderReferralResponseData> riderReferralApi(
    RiderReferralRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.nodeUrl}supervisorReferral',
      request: riderReferralRequestToJson(requestData),
    ),
  );
  return RiderReferralFromJson(response);
}

Future<RiderReferraMessageResponseData> riderRefferalMsgApi(
    RiderReferralMessageRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.nodeUrl}shareReferralCode',
      request: riderReferralMsgRequestToJson(requestData),
    ),
  );
  return RiderRefferalMsgFromJson(response);
}

Future<RiderRefferalHistoryResponseData> riderRefferalHistoryApi(
    RiderReferralHistoryRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.nodeUrl}referralHistory',
      request: riderReferralHistoryRequestToJson(requestData),
    ),
  );
  return RiderRefferalHistoryFromJson(response);
}
