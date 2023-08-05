import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/login/data/verify_user_api_data.dart';

import '../login/service/login_services.dart';
import '../supporting_classes/app_color.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final RxBool showEmailInput = true.obs;
  var apiLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    super.onClose();
  }

  void toggleShowEmailInput() {
    showEmailInput.value = !showEmailInput.value;
  }

  onBackPressed() {
    if (apiLoading.value) return;

    if (showEmailInput.value) {
      SystemNavigator.pop();
    } else {
      toggleShowEmailInput();
    }
  }

  checkValidationAndCallApi() {
    String text = emailController.text.trim();
    if (GetUtils.isEmail(text) || GetUtils.isPhoneNumber(text)) {
      apiLoading.value = true;
      verifyUserNameApi(
        VerifyUserNameRequestData(
          companyDomain: 'regina',
          companyMainDomain: 'limor.us',
          cid: '',
          username: text,
          deviceToken:
              'fAjT6KxtTE-hc_txlFPEXu:APA91bG3xT3yRFa0inWCr-frK30bLrea7Jw7BwaKrV_qwd1y-Wy4qY8nPy9AGHXo3BEE9dhlVclNxk3IbE5WL7hTpMfP2moxvZBIMMj7cpiuPKGLgvHadLya4dVKztpzET06LtRgQ4h5',
        ),
      ).then((response) {
        apiLoading.value = false;
        if (response.status == 1) {
          toggleShowEmailInput();
        } else {
          Get.snackbar('Alert', '${response.message}',
              backgroundColor: AppColors.kGetSnackBarColor.value);
        }
      }).catchError((onError) {
        apiLoading.value = false;
        Get.snackbar('Error!', onError.toString(),
            backgroundColor: AppColors.kGetSnackBarColor.value);
      });
    } else {
      Get.snackbar('Alert', 'Enter valid Email/Phone!',
          backgroundColor: AppColors.kGetSnackBarColor.value);
    }
  }
}
