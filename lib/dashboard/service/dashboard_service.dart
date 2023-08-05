import 'package:get/get_instance/src/get_instance.dart';
import 'package:rsl_supervisor/dashboard/data/shift_in_api_data.dart';

import '../../network/services.dart';
import '../data/dashboard_api_data.dart';

final ApiProvider apiProvider = GetInstance().find<ApiProvider>();

Future<DasboardApiResponse> dashboardApi(DasboardApiRequest requestData) async {
  final response = await apiProvider.postApiCall(
      resource: Resource(
        url: 'https://ridenodeauth.limor.us/passenger/dashboard',
        request: dashboardApiRequestToJson(requestData),
      ),
      key: "Dashboard Api");
  return dashboardApiResponseFromJson(response);
}

Future<ShiftInResponse> shiftInApi(ShiftInRequest requestData) async {
  final response = await apiProvider.postApiCall(
      resource: Resource(
        url: 'https://ridenodeauth.limor.us/passenger/shiftTime',
        request: shiftInApiRequestToJson(requestData),
      ),
      key: "Shift in");
  return shiftInApiResponseFromJson(response);
}
