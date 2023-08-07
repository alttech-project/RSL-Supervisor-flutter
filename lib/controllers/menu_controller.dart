import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rsl_supervisor/controllers/home_controller.dart';

import '../utils/helpers/basic_utils.dart';
import '../utils/helpers/getx_storage.dart';

class SideMenuController extends GetxController {
  late final HomeController _dashController = Get.find<HomeController>();
  late final _storageController = Get.find<GetStorageController>();

  Rx<String?> userId = ''.obs;
  var appVersion = ''.obs;
  var appBuildNumber = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    getUserInfo();
    _getAppInfo();
  }

  getUserInfo() async {
    userId.value = await _storageController.getSupervisorId();
    printLogs("hiSabari UserInfo called in side  ID ${userId.value}");
    return;
  }

  void logout() {
    _dashController.viewEnable.value = false;
    _storageController.removeSupervisorInfo();
    getUserInfo();
  }

  void hideMenu() {
    _dashController.viewEnable.value = false;
  }

  void _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
    appBuildNumber.value = packageInfo.buildNumber;
  }
}
