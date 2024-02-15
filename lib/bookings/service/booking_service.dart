import 'dart:convert';
import 'package:get/get.dart';
import 'package:rsl_supervisor/bookings/data/edit_trip_details_data.dart';

import 'package:rsl_supervisor/bookings/data/save_booking_data.dart';
import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/edit_details_data.dart';
import '../data/get_car_make_fare_data.dart';
import '../data/all_car_makes_data.dart';
import '../data/get_package_data.dart';
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

Future<AllCarMakeListApiResponse> allCarMakesApi() async {
  String url = await _storageController.getBookingsUrl();

  final response = await _apiProvider.httpRequest(
      requestType: RequestType.kGet,
      resource: Resource(
        url: '${url}allCarMakes',
        request: "",
      ),
      queryParam: {"type": "allCarMakes"});
  return allCarMakeListApiResponseFromJson(response);
}

Future<CarMakeFareResponse> getCarMakeFareApi(
    CarMakeFareRequest requestData) async {
  String url = await _storageController.getBookingsUrl();

  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${url}getCarMakeFare',
        request: carMakeFareRequestToJson(requestData),
      ),
      queryParam: {"type": "getCarMakeFare"});
  return carMakeFareResponseFromJson(response);
}

Future<MotorDetailsResponse> motorDetailsApi(
    MotorDetailsRequest requestData) async {
  String url = await _storageController.getBookingsUrl();

  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${url}motorDetails',
        request: motorDetailsRequestToJson(requestData),
      ),
      queryParam: {"type": "motorDetails"});
  return motorDetailsResponseFromJson(response);
}

Future<SaveBookingResponse> saveBookingApi(
    SaveBookingRequest requestData) async {
  String url = await _storageController.getBookingsUrl();

  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${url}supervisorCorporateBooking',
        request: saveBookingRequestToJson(requestData),
      ),
      queryParam: {"type": "supervisorCorporateBooking"});
  return saveBookingResponseFromJson(response);
}

Future<CorporatePackageListApiResponse> getCorporatePackageListApi(
    GetCorporatePackageListRequest requestData) async {
  String url = await _storageController.getBookingsUrl();

  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${url}getCorpratePackageList',
        request: corporatePackageListApiRequestToJson(requestData),
      ),
      queryParam: {"type": "getCorpratePackageList"});
  return corporatePackageListApiResponseFromJson(response);
}

Future<GetByPassengerEditDetailsResponse> getByPassengerEditDetails(
    GetByPassengerEditDetailsRequest requestData) async {
  String url = await _storageController.getBookingsUrl();

  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${url}getByPassengerEditDetails',
        request: getByPassengerEditDetailsRequestToJson(requestData),
      ),
      queryParam: {"type": ""});
  return getByPassengerEditDetailsFromJson(response);
}

Future<EditCorporateBookingResponseData> editBookingApi(
    EditCorporateBookingRequestData requestData) async {
  String url = await _storageController.getBookingsUrl();

  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${url}editCorporateBooking',
        request: editCorporateBookingRequestToJson(requestData),
      ),
      queryParam: {"type": ""});
  return editCorporateBookingResponseFromJson(response);
}
