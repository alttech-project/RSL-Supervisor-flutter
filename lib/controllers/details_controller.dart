import 'package:get/get.dart';

class DetailsController extends GetxController {
  var name = "".obs;

  void setName(var name) {
    this.name.value = name;
  }
}
