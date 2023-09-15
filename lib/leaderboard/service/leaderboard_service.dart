




import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rsl_supervisor/leaderboard/data/leaderboard_api_data.dart';

import '../../network/services.dart';
final ApiProvider _apiProvider = Get.find<ApiProvider>();


Future<LeaderboardApiResponse> leaderboardApi(LeaderboardRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: 'http://15.184.158.127:3004/supervisor/leaderBoard',
      request: leaderboardApiRequestToJson(requestData),
    ),
  );
  return leaderboardApiResponseFromJson(response);
}


