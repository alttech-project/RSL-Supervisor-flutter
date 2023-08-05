import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final RxBool showEmailInput = true.obs;

  void toggleShowEmailInput() {
    showEmailInput.value = !showEmailInput.value;
  }
}
