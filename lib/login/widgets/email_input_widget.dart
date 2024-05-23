import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/login/controller/login_controller.dart';
import 'package:rsl_supervisor/widgets/app_textfields.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/custom_button.dart';

class EmailInputWidget extends GetView<LoginController> {
  const EmailInputWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    final FocusNode emailFocusNode = FocusNode();
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        controller.hideAppVersion(true);
      } else {
        controller.hideAppVersion(false);
      }
    });

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: SizedBox(
            height: ScreenUtil().screenHeight,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome!',
                  style: AppFontStyle.heading(
                    color: AppColors.kPrimaryColor.value,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: UnderlinedTextField(
                    controller: controller.emailController,
                    hint: "Enter your email",
                    inputLblTxt: "Email",
                    keyboardType: TextInputType.emailAddress,
                    focusNode: emailFocusNode,
                    onSubmit: (value) {},
                  ),
                ),
                Obx(
                      () => CustomButton(
                    width: double.maxFinite,
                    linearColor: primaryButtonLinearColor,
                    height: 35.h,
                    borderRadius: 35.h / 2,
                    isLoader: controller.apiLoading.value,
                    style: AppFontStyle.body(color: Colors.white),
                    text: 'Sign in',
                    onTap: () {
                      controller.checkValidationAndCallApi();
                    },
                  ),
                ),
                controller.enableSignUp.value == 1 ?
                Padding(padding: EdgeInsets.only(right: 10.w,top: 20.h),child:
                _signUpWidget()):const SizedBox.shrink(),
              ],
            ),
          ),
        ),
        Obx(
              () => Visibility(
            visible: !controller.showAppVersion.value,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                title: Text(
                  "App Version: ${controller.appBuildNumber.value} (${controller.appVersion.value} - ${controller.apk.value})",
                  style: AppFontStyle.smallText(
                    weight: AppFontWeight.semibold.value,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _signUpWidget() {
    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: () => controller.navigateSignUpPage(),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontSize: AppFontSize.medium.value,
                decorationColor: AppColors.kPrimaryColor.value,
                // Set the underline color
                decorationThickness: 2.0,
                color: AppColors.kPrimaryColor.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


