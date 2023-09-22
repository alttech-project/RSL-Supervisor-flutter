import 'package:get/get.dart';
import 'package:rsl_supervisor/video/data/upload_video_data.dart';
import '../../network/app_config.dart';
import '../../network/services.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();

Future<UploadVideoResponse> uploadVideoApi(
    UploadVideoRequest requestData) async {
  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${AppConfig.nodeUrl}supervisorMonitorLogUpdate',
      request: uploadVideoRequestToJson(requestData),
    ),
  );
  return uploadVideoResponseFromJson(response);
}
