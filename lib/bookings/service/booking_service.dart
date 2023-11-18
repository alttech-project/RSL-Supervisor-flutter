import 'dart:convert';
import 'package:get/get.dart';

import 'package:rsl_supervisor/bookings/data/save_booking_data.dart';
import '../../network/app_config.dart';
import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/motor_details_data.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();
final _storageController = Get.find<GetStorageController>();

Future<Map<String, dynamic>> googleMapApi(
  double pickupLatitude,
  double pickupLongitude,
  double dropLatitude,
  double dropLongitude,
) async {
  String url = await _storageController.getNodeUrl();
  url = url.replaceAll('passnode', 'ridenode');
  final response = await _apiProvider.httpRequest(
    requestType: RequestType.kGet,
    resource: Resource(
      url:
          '${url}getDirections?origin=$pickupLatitude,$pickupLongitude&destination=$dropLatitude,$dropLongitude&mode=driving&key=${"AIzaSyBdqEy6MU7Th1WWKnfckzEDqJG4CWShBvk"}',
      request: '',
    ),
  );
  return json.decode(response);
}

Future<MotorDetailsResponse> motorDetailsApi(
    MotorDetailsRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.newBookingUrl}motorDetails',
        request: motorDetailsRequestToJson(requestData),
      ),
      queryParam: {"type": ""});
  return motorDetailsResponseFromJson(response);
}

Future<SaveBookingResponse> saveBookingApi(
    SaveBookingRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.newBookingUrl}supervisorCorporateBooking',
        request: saveBookingRequestToJson(requestData),
      ),
      queryParam: {"type": ""});
  return saveBookingResponseFromJson(response);
}
