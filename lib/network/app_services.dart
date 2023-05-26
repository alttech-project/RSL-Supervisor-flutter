import 'package:get/get_instance/src/get_instance.dart';
import 'package:get_x_sample/network/services.dart';

import '../data/dashboard_data.dart';

final ApiProvider _apiProvider = GetInstance().find<ApiProvider>();
final callService = ApiProvider();

Future<DashboardResponseData> dashboardApi(
    DashboardRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
      resource: Resource(
          url: "api/StockTakeDashboard",
          request: dashboardRequestDataToJson(requestData)));
  return dashboardResponseDataFromJson(response);
}
