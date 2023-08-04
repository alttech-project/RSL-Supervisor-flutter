import 'package:get/get.dart';
import 'package:rsl_supervisor/controllers/home_controller.dart';

import '../controllers/app_start_controller.dart';
import '../controllers/login_controller.dart';
import '../network/services.dart';
import '../utils/helpers/getx_storage.dart';

class AppBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AppStartController>(() => AppStartController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<GetStorageController>(() => GetStorageController());
  }
}
