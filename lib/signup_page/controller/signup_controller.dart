import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

import '../../shared/styles/app_color.dart';
import '../../utils/helpers/basic_utils.dart';
import '../data/supervisor_signUp.dart';
import '../service/signUp_api.dart';

class SignUpController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController uniqueNumberController = TextEditingController();
  RxBool apiLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_updateUniqueNumber);
    phoneNumberController.addListener(_updateUniqueNumber);
  }

  @override
  void onClose() {
    // Remove listeners to prevent memory leaks
    nameController.removeListener(_updateUniqueNumber);
    phoneNumberController.removeListener(_updateUniqueNumber);

    nameController.dispose();
    phoneNumberController.dispose();
    uniqueNumberController.dispose();

    super.onClose();
  }

  void _updateUniqueNumber() {
    final nameText = nameController.text;
    final phoneText = phoneNumberController.text;

    // Get the first three letters of the name
    final namePart = nameText.length >= 3 ? nameText.substring(0, 3) : nameText;

    // Get the first three digits of the phone number
    final phonePart = phoneText.length >= 3 ? phoneText.substring(0, 3) : phoneText;

    // Update the unique number controller
    uniqueNumberController.text = namePart + phonePart;
  }

  void checkValidation() {
    final name = nameController.text.trim();
    final phone = phoneNumberController.text.trim();
    final email = emailController.text.trim();
    final uniqueNumber = uniqueNumberController.text.trim();

    if (name.isEmpty) {
      _showSnackBar('Validation!', 'Enter a valid name!');
    } else if (email.isEmpty || !GetUtils.isEmail(email)) {
      _showSnackBar('Validation!', 'Enter a valid Email!');
    } else if (phone.isEmpty || !GetUtils.isPhoneNumber(phone)) {
      _showSnackBar('Validation!', 'Enter a valid phone number!');
    } else if (uniqueNumber.isEmpty) {
      _showSnackBar('Validation!', 'Enter a valid Unique Number!');
    } else {
      checkValidationAndCallApi(email, name, phone, uniqueNumber);
    }
  }

  void checkValidationAndCallApi(
      String email, String name, String phone, String uniqueId) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    apiLoading.value = true;
    signUpAPi(
      SignUpApiRequestedData(
          email: email, name: name, phone: phone, uniqueId: uniqueId),
    ).then(
          (response) {
        apiLoading.value = false;
        printLogs("response---->${response.status}");
        printLogs("message---->${response.message}");
        if (response.status == 1) {
          Get.back();
          Get.snackbar('Message', response.message ?? "",
              backgroundColor: AppColors.kGetSnackBarColor.value);
        } else {
          _showSnackBar("Alert", response.message ?? "");
        }
      },
    ).catchError(
          (onError) {
        apiLoading.value = false;
        Get.snackbar('Error!', onError.toString(),
            backgroundColor: AppColors.kGetSnackBarColor.value);
      },
    );
  }

  void _showSnackBar(String title, String message) =>
      showSnackBar(msg: message, title: title);
}
