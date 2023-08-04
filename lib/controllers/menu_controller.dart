import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rsl_supervisor/controllers/home_controller.dart';

import '../utils/helpers/basic_utils.dart';
import '../utils/helpers/getx_storage.dart';

class SideMenuController extends GetxController {
  HomeController dashController = Get.find<HomeController>();
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
    userId.value = await GetStorageController().getUserId();
    printLogs("hiSabari UserInfo called in side  ID ${userId.value}");
    return;
  }

  void logout() {
    dashController.viewEnable.value = false;
    GetStorageController().setEmptyUserInfo();
    getUserInfo();
  }

  void hideMenu() {
    dashController.viewEnable.value = false;
  }

  void _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
    appBuildNumber.value = packageInfo.buildNumber;
  }
}
