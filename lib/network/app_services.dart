import 'package:get/get_instance/src/get_instance.dart';
import 'package:rsl_supervisor/network/services.dart';

import '../data/dashboard_data.dart';

final ApiProvider _apiProvider = GetInstance().find<ApiProvider>();
final callService = ApiProvider();

Future<DashboardResponseData> dashboardApi(
    DashboardRequestData requestData) async {
  final response = await _apiProvider.postApiCall(
      resource: Resource(
          url: "api/StockTakeDashboard",
          request: dashboardRequestDataToJson(requestData)),
      key: "Home");
  return dashboardResponseDataFromJson(response);
}
