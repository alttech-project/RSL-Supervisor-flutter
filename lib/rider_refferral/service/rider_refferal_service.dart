

import 'package:get/get.dart';
import 'package:rsl_supervisor/network/app_config.dart';
import 'package:rsl_supervisor/rider_refferral/data/rider_refferal_api_data.dart';

import '../../network/services.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();



Future<RiderRefferalResponseData> riderRefferaAPi(
    RiderReferralRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: 'https://passnode.limor.us/passenger/supervisorReferral',
      request: riderReferralRequestToJson(requestData),
    ),
  );
  return RiderRefferalFromJson(response);
}


Future<RiderReferraMessageResponseData> riderRefferalMsgApi(
    RiderReferraMessageRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: 'https://passnode.limor.us/passenger/shareReferralCode',
      request: riderReferralMsgRequestToJson(requestData),
    ),
  );
  return RiderRefferalMsgFromJson(response);
}


Future<RiderRefferalHistoryResponseData> riderRefferalHistoryApi(
    RiderRefferalHistoryRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: 'https://passnode.limor.us/passenger/referralHistory',
      request: riderReferralHistoryRequestToJson(requestData),
    ),
  );
  return RiderRefferalHistoryFromJson(response);
}