import 'package:get/get.dart';
import 'package:rsl_supervisor/network/app_config.dart';

import '../../network/services.dart';
import '../data/quick_trip_api_data.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<DispatchQuickTripResponseData> dispatchQuickTripApi(
    DispatchQuickTripRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.webBaseUrl}dispatchquicktrips_new',
      request: dispatchQuickTripRequestToJson(requestData),
    ),
  );
  return dispatchQuickTripResponseFromJson(response);
}
