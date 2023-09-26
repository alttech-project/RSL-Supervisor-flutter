import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../network/app_config.dart';
import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/splash_data.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();
final _storageController = Get.find<GetStorageController>();

Future<GetCoreResponse> getCoreApi() async {
  String url = AppConfig.webBaseUrl;
  final response = await _apiProvider.httpRequest(
    requestType: RequestType.kGet,
    resource: Resource(
      url: '${url}getcore_config',
      request: '',
    ),
  );
  return getCoreApiResponseFromJson(response);
}
