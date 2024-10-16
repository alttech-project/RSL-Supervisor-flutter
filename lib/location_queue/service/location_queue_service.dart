import 'package:rsl_supervisor/location_queue/data/add_driver_data.dart';
import 'package:rsl_supervisor/location_queue/data/driver_list_data.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/location_queue/data/driver_queue_position_data.dart';
import 'package:rsl_supervisor/location_queue/data/save_booking_data.dart';

import '../../network/app_config.dart';
import '../../network/services.dart';
import '../data/search_driver_data.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<DriverListResponse> driverListApi(DriverListRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}driver_list_new',
        request: driverListApiRequestToJson(requestData),
      ),
      queryParam: {"type": "driver_list_new"});
  return driverListApiResponseFromJson(response);
}

Future<DriverQueuePositionResponse> driverQueuePositionApi(
    DriverQueuePositionRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}driver_queue_position_new',
        request: driverQueuePositionRequestToJson(requestData),
      ),
      queryParam: {"type": "driver_queue_position_new"});
  return driverQueuePositionResponseFromJson(response);
}

Future<DriverListResponse> updateDriverQueueApi(
    UpdateDriverQueueRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}reorder_shift_driver_queue',
        request: updateDriverQueueRequestToJson(requestData),
      ),
      queryParam: {"type": "reorder_shift_driver_queue"});
  return driverListApiResponseFromJson(response);
}

Future<AddDriverResponse> addDriverApi(AddDriverRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}add_driverto_queue_new',
        request: addDriverRequestToJson(requestData),
      ),
      queryParam: {"type": "add_driverto_queue_new"});

  return addDriverResponseFromJson(response);
}

Future<SearchDriverResponse> searchDriverApi(
    SearchDriverRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}search_driver_by_fleet_new',
        request: driverSearchRequestToJson(requestData),
      ),
      queryParam: {"type": "search_driver_by_fleet_new"});
  return searchDriverResponseFromJson(response);
}

Future<SaveBookingResponse> saveBookingApi(
    SaveBookingRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}supervisorSaveBooking_new',
        request: saveBookingRequestToJson(requestData),
      ),
      queryParam: {"type": "supervisorSaveBooking_new"});
  return saveBookingResponseFromJson(response);
}
