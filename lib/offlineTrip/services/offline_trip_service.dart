import 'package:get/get.dart';
import 'package:rsl_supervisor/offlineTrip/data/offline_trip_api_data.dart';

import '../../network/app_config.dart';
import '../../network/services.dart';
import '../data/taxi_list_api_data.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<TaxiListResponseData> taxiListApi(
    TaxiListRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}get_auto_search_taxi',
        request: taxiListRequestToJson(requestData),
      ),
      queryParam: {"type": "get_auto_search_taxi"});
  return taxiListResponseFromJson(response);
}

Future<DispatchOfflineTripResponseData> offlineTripApi(
    DispatchOfflineTripRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}dispatch_offline_trips_new',
        request: dispatchOfflineTripRequestToJson(requestData),
      ),
      queryParam: {"type": "dispatch_offline_trips_new"});
  return dispatchOfflineTripResponseFromJson(response);
}
