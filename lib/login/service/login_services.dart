import 'package:get/get.dart';
import 'package:rsl_supervisor/network/app_config.dart';

import '../../network/services.dart';
import '../data/verify_user_api_data.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<VerifyUserNameResponseData> verifyUserNameApi(
    VerifyUserNameRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.webBaseUrl}get_login_temporary_password_supervisor',
      request: verifyUserNameRequestToJson(requestData),
    ),
  );
  return verifyUserNameResponseFromJson(response);
}
