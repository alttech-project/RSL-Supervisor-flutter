import 'package:get/get.dart';
import '../../network/app_config.dart';
import '../../network/services.dart';
import '../data/splash_data.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

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
