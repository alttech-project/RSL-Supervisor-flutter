import 'package:get/get.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';

import '../../app.dart';
import '../utils/helpers/getx_storage.dart';

class AppStartController extends GetxController {
  final GetStorageController _storageController =
      Get.find<GetStorageController>();
  var supervisorId = "";
  @override
  void onInit() {
    super.onInit();
    getDeviceToken();
  }

  getDeviceToken() async {
    supervisorId = await _storageController.getSupervisorId();
  }

  Future<Status> checkLoginStatus() async {
    int? status = 2;
    printLogs("Time 1 ${DateTime.now().second}");
    await Future.delayed(const Duration(seconds: 4));
    printLogs("Time 2 ${DateTime.now().second}");
    printLogs("supervisorId: $supervisorId");
    if (supervisorId.isEmpty) {
      status = 2;
    } else {
      status = 1;
    }
    return Status(status: status);
  }
}
