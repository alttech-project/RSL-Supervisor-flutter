import 'package:get/get.dart';
import 'package:rsl_supervisor/login/data/assign_supervisor_api_data.dart';
import 'package:rsl_supervisor/login/data/verify_otp_api_data.dart';
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
      queryParam: {"type": "get_login_temporary_password_supervisor"});
  return verifyUserNameResponseFromJson(response);
}

Future<VerifyOtpResponse> verifyOtpApi(VerifyOtpRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url:
            '${AppConfig.webBaseUrl}login_with_temporary_password_supervisor_new',
        request: verifyOtpRequestToJson(requestData),
      ),
      queryParam: {"type": "login_with_temporary_password_supervisor_new"});
  return verifyOtpResponseFromJson(response);
}

Future<AssignSupervisorResponse> assignSupervisorApi(
    AssignSupervisorRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}assign_acting_supervisor_new',
        request: assignSupervisorRequestToJson(requestData),
      ),
      queryParam: {"type": "assign_acting_supervisor_new"});
  return assignSupervisorResponseFromJson(response);
}
