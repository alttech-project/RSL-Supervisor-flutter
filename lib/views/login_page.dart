import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/supporting_classes/app_color.dart';

import '../controllers/login_controller.dart';
import '../supporting_classes/app_font.dart';
import '../widgets/custom_button.dart';
import '../widgets/safe_area_container.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.onBackPressed();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.kBlack.value,
        extendBodyBehindAppBar: true,
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SafeAreaContainer(
            statusBarColor: AppColors.kBlack.value,
            systemNavigationBarColor: AppColors.kBlack.value,
            navigationBarthemedark: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: controller.showEmailInput.value
                        ? _buildEmailInput()
                        : _buildOtpInput(),
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(
                  () => CustomButton(
                    width: double.maxFinite,
                    linearColor: primaryButtonLinearColor,
                    height: 35.h,
                    borderRadius: 25.r,
                    isLoader: controller.apiLoading.value,
                    style:
                        TextStyle(color: AppColors.kSecondaryTextColor.value),
                    text:
                        controller.showEmailInput.value ? 'Continue' : 'Login',
                    onTap: () => controller.checkValidationAndCallApi(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome!',
          style: AppFontStyle.subHeading(
            color: AppColors.kPrimaryColor.value,
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        TextFormField(
          key: const Key('emailInput'),
          // Use a key for smooth AnimatedSwitcher transition
          controller: controller.emailController,
          style: const TextStyle(
            color: Colors.white, // Set the label text color here
            fontWeight:
                FontWeight.normal, // Set the label text font weight here
          ),
          keyboardType: TextInputType.emailAddress,
          maxLines: 1,
          cursorColor: AppColors.kPrimaryColor.value,
          autofocus: false,
          onFieldSubmitted: (value) => controller.checkValidationAndCallApi(),
          decoration: InputDecoration(
            labelText: 'Email/Phone',
            labelStyle: const TextStyle(
              color: Colors.white70, // Set the label text color here
              fontWeight:
                  FontWeight.bold, // Set the label text font weight here
            ),
            hintText: 'Enter your email/phone here',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
            border: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white), // Set the border color here
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey), // Set the enabled border color here
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white), // Set the focused border color here
            ),
            focusColor: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return TextFormField(
      key: const Key('otpInput'),
      // Use a key for smooth AnimatedSwitcher transition
      controller: controller.otpController,
      decoration: const InputDecoration(
        labelText: 'OTP',
        border: OutlineInputBorder(),
      ),
    );
  }
}
