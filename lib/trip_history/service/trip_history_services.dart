import 'package:get/get.dart';
import 'package:rsl_supervisor/trip_history/data/cancel_trip_data.dart';
import 'package:rsl_supervisor/trip_history/data/export_pdf_data.dart';
import 'package:rsl_supervisor/trip_history/data/trip_history_data.dart';
import 'package:rsl_supervisor/trip_history/data/trip_history_map_data.dart';

import '../../network/app_config.dart';
import '../../network/services.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<TripHistoryResponse> tripHistoryApi(
    TripHistoryRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.webBaseUrl}trip_history',
      request: tripHistoryRequestToJson(requestData),
    ),
  );
  return tripHistoryResponseFromJson(response);
}

Future<ExportPdfResponse> exportPdfApi(ExportPdfRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.webBaseUrl}export_pdf',
      request: exportPdfRequestToJson(requestData),
    ),
  );
  return exportPdfResponseFromJson(response);
}

Future<CancelTripResponse> cancelTripApi(CancelTripRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.webBaseUrl}cancel_supervisor_trip',
      request: cancelTripRequestToJson(requestData),
    ),
  );
  return camcelTripResponseFromJson(response);
}

Future<EditFareResponseData> editFareApi(EditFareRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.webBaseUrl}update_trip_fare',
      request: editFareRequestToJson(requestData),
    ),
  );
  return editFareResponseFromJson(response);
}


Future<TripHistoryMapResponseData> tripHistoryMapApi(TripHistoryMapRequestedData requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url:'${AppConfig.webBaseUrl}trip_map_datas',
      request: tripHistoryMapRequestToJson(requestData),
    ),
  );
  return tripHistoryMapResponseFromJson(response);
}