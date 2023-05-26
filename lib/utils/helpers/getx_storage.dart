
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class GetStorageController extends GetxController {
  final storage = GetStorage();

  void saveTokenData({required String value}) {
    storage.write("token", value);
  }

  Future<String> getTokenData() async {
   final  token= await storage.read("token")??"";
    return token;
  }

  void removeTokeData() {
    storage.remove("token");
  }
}
