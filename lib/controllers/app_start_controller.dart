import 'package:get/get.dart';

import '../../app.dart';
import '../utils/helpers/getx_storage.dart';

class AppStartController extends GetxController {
  Future<Status> checkLoginStatus(
      GetStorageController storageController) async {
    await Future.delayed(const Duration(seconds: 4));
    int? status = 2;
    final userInfo = await storageController.getUserId();
    if (userInfo.isEmpty) {
      status = 2;
    } else {
      status = 1;
    }
    return Status(status: status);
  }
}
