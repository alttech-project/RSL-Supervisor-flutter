import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rsl_supervisor/subscribers/data/subscriber_list_api_data.dart';

import '../../network/app_config.dart';
import '../../network/services.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<SubscriberListResponseData> subscribeListApi(
    SubscriberListRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
        url: '${AppConfig.webBaseUrl}driver_list_by_taxi_subscription',
        request: subscriberListRequestToJson(requestData),
      ),
      queryParam: {"type": "driver_list_by_taxi_subscription"});
  return subscriberListResponseFromJson(response);
}
