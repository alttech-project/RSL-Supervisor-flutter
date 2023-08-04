
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

  void saveUserId({required String id}) {
    storage.write("userId", id);
  }

  void removeUserId() {
    storage.remove("userId");
  }

  Future<String> getUserId() async {
    final userId = await storage.read("userId") ?? "";
    return userId;
  }

  void setEmptyUserInfo() {
    storage.write("userInfo", "");
    storage.write("userId", "");
  }
}
