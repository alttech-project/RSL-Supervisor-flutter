import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../network/app_config.dart';
import '../../network/services.dart';
import '../data/my_trip_list_data.dart';
import '../data/my_trip_list_cancel_trip_data.dart';
import '../data/my_trip_list_export_pdf_data.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<MyTripsResponseData> tripListApi(MyTripsRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}supervisor_trip_list',
        request: tripListRequestToJson(requestData),
      ),
      queryParam: {"type": "supervisor_trip_list"});
  return tripListResponseFromJson(response);
}

Future<ExportPdfResponseData> listexportPdfApi(
    ExportPdfRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}supervisor_trip_export_pdf',
        request: tripListexportPdfRequestToJson(requestData),
      ),
      queryParam: {"type": "supervisor_trip_export_pdf"});
  return tripListexportPdfResponseFromJson(response);
}

Future<tripListCancelTripResponse> ListcancelTripApi(
    tripListCancelTripRequest requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}cancel_supervisor_trip',
        request: cancelTripRequestToJson(requestData),
      ),
      queryParam: {"type": "cancel_supervisor_trip"});
  return cancelTripResponseFromJson(response);
}
