import 'package:get/get.dart';
import 'package:rsl_supervisor/video/data/upload_video_data.dart';
import '../../network/app_config.dart';
import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();
final _storageController = Get.find<GetStorageController>();

Future<UploadVideoResponse> uploadVideoApi(
    UploadVideoRequest requestData) async {
  String url = await _storageController.getNodeUrl();

  final response = await _apiProvider.httpRequest(
    resource: Resource(
      url: '${url}supervisorMonitorLogUpdate',
      request: uploadVideoRequestToJson(requestData),
    ),
  );
  return uploadVideoResponseFromJson(response);
}
