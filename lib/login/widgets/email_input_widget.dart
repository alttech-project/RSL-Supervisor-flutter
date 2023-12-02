import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/login/controller/login_controller.dart';
import 'package:rsl_supervisor/widgets/app_textfields.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/custom_button.dart';

class EmailInputWidget extends GetView<LoginController> {
  const EmailInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[

      Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
        ],
      ),

      Align(
        alignment: Alignment.bottomLeft,
        child: Obx(
              () => ListTile(
            title: Text(
              "App Version: ${controller.appBuildNumber.value} (${controller.appVersion.value} - ${controller.apk.value})",
              style: AppFontStyle.smallText(
                  weight: AppFontWeight.semibold.value, color: Colors.white54),
            ),
          ),
        ),
      ),

    ]);
  }
}
