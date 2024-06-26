import 'package:get/get.dart';
import 'package:rsl_supervisor/dashboard/data/car_model_type_api.dart';
import 'package:rsl_supervisor/dashboard/data/logout_api_data.dart';
import 'package:rsl_supervisor/dashboard/data/shift_in_api_data.dart';

import '../../network/app_config.dart';
import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/dashboard_api_data.dart';
import '../data/verify_supervisor_location.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();
final _storageController = Get.find<GetStorageController>();

Future<DasboardApiResponse> dashboardApi(DasboardApiRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${await _storageController.getNodeUrl()}dashboard',
      request: dashboardApiRequestToJson(requestData),
    ),
  );
  return dashboardApiResponseFromJson(response);
}

Future<ShiftInResponse> shiftInApi(ShiftInRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${await _storageController.getNodeUrl()}shiftTime',
      request: shiftInApiRequestToJson(requestData),
    ),
  );
  return shiftInApiResponseFromJson(response);
}

Future<LogoutApiResponse> logoutApi(LogoutApiRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}unassign_acting_supervisor',
        request: logoutApiRequestToJson(requestData),
      ),
      queryParam: {"type": "unassign_acting_supervisor"});
  return logoutApiResponseFromJson(response);
}

Future<CarModelTypeResponseData> carModelApi(
    CarModelTypeRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}carmodel_list_new',
        request: carModelApiRequestToJson(requestData),
      ),
      queryParam: {"type": "carmodel_list_new"});
  return carModelApiResponseFromJson(response);
}

Future<VerifySuperVisorLocationResponseData> verifySuperVisorLocation(
    VerifySuperVisorLocationRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}verify_supervisor_location',
        request: verifyLogoutApiRequestToJson(requestData),
      ),
      queryParam: {"type": "verify_supervisor_location"});
  return verifyLogoutApiResponseFromJson(response);
}
