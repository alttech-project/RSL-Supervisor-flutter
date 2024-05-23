


import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../network/app_config.dart';
import '../../network/services.dart';
import '../data/deactivate_account_dart.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();


Future<DeactivateAccountResponseData> accountDeactivateApi(DeactivateAccountRequestedData requestData) async {

  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}deactivate_account',
        request: deActivateApiRequestToJson(requestData),
      ),
      queryParam: {"type": "deactivate_account"});
  return deActivateApiResponseFromJson(response);
}