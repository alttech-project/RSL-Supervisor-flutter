import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../services/splash_services.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    callGetCoreApi();
  }

  void callGetCoreApi() {
    getCoreApi().then(
      (response) {
        if ((response.status ?? 0) == 1) {
          if (response.details != null) {
            var details = response.details;
            GetStorageController()
                .saveMonitorNodeUrl(url: details?.monitorNodeUrl ?? "");
            GetStorageController()
                .saveNodeUrl(url: details?.referralNodeUrl ?? "");
            GetStorageController().saveRiderReferralUrl(
                url: details?.supervisorRiderReferral ?? 0);
            GetStorageController()
                .saveVideoDate(date: details?.videoDate ?? "");
            GetStorageController().saveImageDate(date: details?.imgDate ?? "");
          }
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
}
