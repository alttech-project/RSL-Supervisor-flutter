import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../leaderboard_new/data/leaderboard_api_data_new.dart';
import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();
final _storageController = Get.find<GetStorageController>();

Future<LeaderboardApiResponse> leaderboardApi(
    LeaderboardRequestData requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${await _storageController.getMonitorNodeUrl()}supervisorLeaderBoard',
      request: leaderboardApiRequestToJson(requestData),
    ),
  );
  return leaderboardApiResponseFromJson(response);
}
