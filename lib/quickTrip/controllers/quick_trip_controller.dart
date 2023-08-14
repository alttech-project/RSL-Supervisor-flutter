import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/styles/app_color.dart';

class QuickTripController extends GetxController {
  final TextEditingController tripIdController = TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController paymentIdController = TextEditingController();

  var countryCode = '971'.obs;
  var isApiLoading = false.obs;

  @override
  void onInit() {
    print('hiTamil QTC onInit');
    super.onInit();
  }

  @override
  void onReady() {
    print('hiTamil QTC onReady');
    super.onReady();
  }

  @override
  void onClose() {
    print('hiTamil QTC onClose');
    tripIdController.dispose();
    dropLocationController.dispose();
    fareController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    paymentIdController.dispose();
    super.onClose();
  }

  void clearTripId() {
    tripIdController.clear();
  }

  void clearDropLocation() {
    dropLocationController.clear();
  }

  void checkValidation() {
    final tripID = tripIdController.text.trim();
    final dropLocation = dropLocationController.text.trim();
    final fare = fareController.text.trim();
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final paymentId = paymentIdController.text.trim();

    //GetUtils.isEmail(text) || GetUtils.isPhoneNumber(text)
    if (tripID.isEmpty) {
      _showSnackBar('Validation!', 'Enter a valid Trip ID!');
    } else if (dropLocation.isEmpty) {
      _showSnackBar('Validation!', 'Select / Enter a valid drop location!');
    } else if (phone.isNotEmpty && !GetUtils.isPhoneNumber(phone)) {
      _showSnackBar('Validation!', 'Enter a valid phone number!');
    } else if (email.isNotEmpty && !GetUtils.isEmail(email)) {
      _showSnackBar('Validation!', 'Enter a valid Email!');
    } else {
      _showSnackBar('Success!', 'All validation completed!');
    }
  }

  void _showSnackBar(String title, String message) {
    Get.snackbar(title, message,
        backgroundColor: AppColors.kGetSnackBarColor.value);
  }
}
