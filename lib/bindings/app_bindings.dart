import 'package:get/get.dart';
import 'package:get_x_sample/controllers/details_controller.dart';
import 'package:get_x_sample/controllers/home_controller.dart';

class AppBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DetailsController>(() => DetailsController());
  }
}
