import 'package:get/get.dart';
import 'package:rsl_supervisor/feeds/data/feeds_api_data.dart';
import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();
final _storageController = Get.find<GetStorageController>();

Future<FeedsApiResponse> feedsApi(FeedsApiRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${await _storageController.getNodeUrl()}supervisorMonitorList',
      request: feedsApiRequestToJson(requestData),
    ),
  );
  return feedsApiResponseFromJson(response);
}
