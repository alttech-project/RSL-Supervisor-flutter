import 'package:get/get.dart';
import 'package:rsl_supervisor/network/app_config.dart';
import 'package:rsl_supervisor/rider_refferral/data/rider_referral_api_data.dart';

import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();
final _storageController = Get.find<GetStorageController>();

Future<RiderReferralResponseData> riderReferralApi(
    RiderReferralRequest requestData) async {
  String url = await _storageController.getNodeUrl();

  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${url}supervisorReferral',
      request: riderReferralRequestToJson(requestData),
    ),
  );
  return RiderReferralFromJson(response);
}

Future<RiderReferraMessageResponseData> riderRefferalMsgApi(
    RiderReferralMessageRequestData requestData) async {
  String url = await _storageController.getNodeUrl();

  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${url}shareReferralCode',
      request: riderReferralMsgRequestToJson(requestData),
    ),
  );
  return RiderRefferalMsgFromJson(response);
}

Future<RiderRefferalHistoryResponseData> riderRefferalHistoryApi(
    RiderReferralHistoryRequestData requestData) async {
  String url = await _storageController.getNodeUrl();

  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${url}referralHistory',
      request: riderReferralHistoryRequestToJson(requestData),
    ),
  );
  return RiderRefferalHistoryFromJson(response);
}
