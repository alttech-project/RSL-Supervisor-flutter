import 'package:get/get.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';
import '../../app.dart';
import '../utils/helpers/getx_storage.dart';

class AppStartController extends GetxController {
  Future<Status> checkLoginStatus(
      GetStorageController storageController) async {
    final userInfo = await storageController.getSupervisorInfo();
    await Future.delayed(const Duration(seconds: 4));
    int? status = 2;

    if ((userInfo.supervisorId ?? "").isEmpty) {
      status = 2;
    } else {
      status = 1;
    }
    printLogs("AppStartController status: $status");
    return Status(status: status);
  }
}
