import 'package:get/get.dart';
import 'package:rsl_supervisor/trip_history/data/trip_history_response.dart';

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
