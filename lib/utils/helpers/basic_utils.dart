import 'package:get/get.dart';

import '../../shared/styles/app_color.dart';

void printLogs(Object object) {
  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (!isProduction) {
    // ignore: avoid_print
    print("$object");
  }
}

void showSnackBar(String message, {String title = 'Alert'}) {
  Get.snackbar(title, message,
      backgroundColor: AppColors.kGetSnackBarColor.value);
}
