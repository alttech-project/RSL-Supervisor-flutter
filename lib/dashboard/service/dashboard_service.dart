import 'package:get/get.dart';
import 'package:rsl_supervisor/dashboard/data/shift_in_api_data.dart';

import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/dashboard_api_data.dart';

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
