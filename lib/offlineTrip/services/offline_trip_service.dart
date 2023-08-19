import 'package:get/get.dart';

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
  );
  return taxiListResponseFromJson(response);
}
