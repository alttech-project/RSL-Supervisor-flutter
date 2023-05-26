import 'package:get/get.dart';
import 'package:get_x_sample/controllers/details_controller.dart';
import 'package:get_x_sample/controllers/home_controller.dart';

import '../network/services.dart';
import '../utils/helpers/getx_storage.dart';

class AppBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DetailsController>(() => DetailsController());
    Get.lazyPut< ApiProvider >(() => ApiProvider());
    Get.lazyPut< GetStorageController >(() => GetStorageController());
  }
}
