



import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../network/app_config.dart';
import '../../network/services.dart';
import '../data/supervisor_signUp.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<SignUpApiResponseData> signUpAPi(SignUpApiRequestedData requestData) async {

  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}supervisor_signup',
        request: signUpApiRequestToJson(requestData),
      ),
      queryParam: {"type": "supervisor_signup"});
  return signUpApiResponseFromJson(response);
}