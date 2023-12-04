import 'package:get/get.dart';
import 'package:rsl_supervisor/driver_list/data/driver_list_api_data.dart';
import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';
import 'package:rsl_supervisor/network/app_config.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<DriverListResponse> driverListApi(DriverListRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}location_driver_list_logs',
        request: driverListApiRequestToJson(requestData),
      ),
      queryParam: {"type": "location_driver_list_logs"});
  return driverListApiResponseFromJson(response);
}
