import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../network/app_config.dart';
import 'basic_utils.dart';
import 'getx_storage.dart';

enum BaseUrls { demo, live }

extension BaseURLHelper on BaseUrls {
  String get rawValue {
    switch (this) {
      case BaseUrls.demo:
        return 'http://3.108.72.20:8451/';
      case BaseUrls.live:
        return 'http://3.108.72.20:8451/';
      default:
        return 'http://34.235.139.192:2200/';
    }
  }
}

class AppInfo {
  static AppInfoPlusArgs? appInfo;
  static String kAppBaseUrl = BaseUrls.demo.rawValue;
}

class AppInfoPlusArgs {
  String? deviceType;
  String? deviceId;
  String? versionCode;
  String? versionName;
  String? cid;

  AppInfoPlusArgs(
      {this.deviceType,
      this.deviceId,
      this.versionCode,
      this.versionName,
      this.cid});
}

getAppInfo() async {
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SupervisorInfo supervisorInfo =
        await GetStorageController().getSupervisorInfo();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo? androidInfo = await deviceInfo.androidInfo;
      printLogs("Device Info Android");
      AppInfo.appInfo = AppInfoPlusArgs(
          deviceId: androidInfo.id,
          deviceType: "a",
          versionName: packageInfo.version,
          versionCode: packageInfo.buildNumber,
          cid: supervisorInfo.cid ?? "");
    } else if (GetPlatform.isIOS) {
      IosDeviceInfo? iosInfo = await deviceInfo.iosInfo;
      printLogs("Device Info Ios");
      AppInfo.appInfo = AppInfoPlusArgs(
          deviceId: iosInfo.identifierForVendor,
          deviceType: "i",
          versionName: packageInfo.version,
          versionCode: packageInfo.buildNumber,
          cid: supervisorInfo.cid ?? "");
    }
    printLogs("Device info success ${AppInfo.appInfo?.deviceId}");
  } catch (error) {
    printLogs("Device info not get it");
  }
  return;
}
