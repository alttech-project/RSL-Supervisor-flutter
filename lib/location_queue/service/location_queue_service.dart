import 'package:rsl_supervisor/location_queue/data/add_driver_response.dart';
import 'package:rsl_supervisor/location_queue/data/driver_list_response.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/location_queue/data/driver_queue_position_response.dart';

import '../../network/app_config.dart';
import '../../network/services.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<DriverListResponse> driverListApi(DriverListRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.webBaseUrl}driver_list',
      request: driverListApiRequestToJson(requestData),
    ),
  );
  return driverListApiResponseFromJson(response);
}

Future<DriverQueuePositionResponse> driverQueuePositionApi(
    DriverQueuePositionRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.webBaseUrl}driver_list',
      request: driverQueuePositionRequestToJson(requestData),
    ),
  );
  return driverQueuePositionResponseFromJson(response);
}

Future<DriverListResponse> updateDriverQueueApi(
    UpdateDriverQueueRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.webBaseUrl}update_driver_queue_new',
      request: updateDriverQueueRequestToJson(requestData),
    ),
  );
  return driverListApiResponseFromJson(response);
}

Future<AddDriverResponse> addDriverApi(AddDriverRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.webBaseUrl}add_driverto_queue_new',
      request: addDriverRequestToJson(requestData),
    ),
  );
  return addDriverResponseFromJson(response);
}
