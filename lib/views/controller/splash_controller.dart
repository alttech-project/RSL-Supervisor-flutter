import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import '../../routes/app_routes.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../services/splash_services.dart';

class SplashController extends GetxController {
  RxBool isSplashScreen = true.obs;
  final storageController = Get.find<GetStorageController>();
  RxDouble height = 0.0.obs;
  RxDouble width = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        height.value = ScreenUtil().screenHeight / 2;
        width.value = ScreenUtil().screenWidth / 2;
      },
    );
    _callGetCoreApi();
  }

  void _callGetCoreApi() {
    getCoreApi().then(
      (response) {
        if ((response.status ?? 0) == 1) {
          if (response.details != null) {
            var details = response.details;
            storageController.saveMonitorNodeUrl(
                url: details?.monitorNodeUrl ?? "");
            storageController.saveNodeUrl(url: details?.referralNodeUrl ?? "");
            storageController.saveRiderReferralUrl(
                url: details?.supervisorRiderReferral ?? 0);
            storageController.saveVideoDate(date: details?.videoDate ?? "");
            storageController.saveImageDate(date: details?.imgDate ?? "");
          }
          _checkLoginStatus();
        } else {
          showSnackBar(
            title: 'Alert',
            msg: response.message ?? "Something went wrong...",
          );
        }
      },
    ).onError(
      (error, stackTrace) {
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final userInfo = await storageController.getSupervisorInfo();
    if ((userInfo.supervisorId ?? "").isEmpty) {
      isSplashScreen.value = false;
      Get.offAllNamed(AppRoutes.loginPage);
    } else {
      isSplashScreen.value = false;
      Get.offAllNamed(AppRoutes.dashboardPage);
    }
  }
}
