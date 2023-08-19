import 'package:get/get.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';

void printLogs(Object object) {
  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (!isProduction) {
    // ignore: avoid_print
    print("$object");
  }
}

showSnackBar({required String title, required String msg}) {
  Get.closeCurrentSnackbar();
  return Get.snackbar(
    title,
    msg,
    snackPosition: SnackPosition.TOP,
    backgroundColor: AppColors.kGetSnackBarColor.value,
    duration: const Duration(seconds: 3),
    animationDuration: const Duration(seconds: 1),
  );
}
