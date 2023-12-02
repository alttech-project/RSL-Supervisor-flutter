import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:rsl_supervisor/login/controller/login_controller.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';
import 'package:rsl_supervisor/widgets/custom_button.dart';
import 'package:rsl_supervisor/widgets/navigation_title.dart';

class VerifyOTPWidget extends GetView<LoginController> {
  const VerifyOTPWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          NavigationTitle(
            title: "Verify OTP",
            onTap: () => controller.onBackPressed(),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            "code is sent to ${controller.emailController.text}",
            maxLines: 2,
            style: AppFontStyle.body(color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.h),
            child: OTPTextField(
              controller: controller.otpController,
              length: 4,
              width: ((45.w * 4) + (10.w * 3)),
              spaceBetween: 10.w,
              fieldWidth: 45.w,
              outlineBorderRadius: 8.r,
              style: TextStyle(
                fontSize: 22.sp,
                color: Colors.white,
                fontWeight: AppFontWeight.bold.value,
              ),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.box,
              otpFieldStyle: OtpFieldStyle(
                  backgroundColor: AppColors.kOtpFieldColor.value),
              onCompleted: (pin) {
                printLogs("OTP Completed: $pin");
                controller.otp.value = pin;
                controller.calVerfyOtpApi();
              },
              onChanged: (pin) {
                printLogs("OTP onChanged: $pin");
                controller.otp.value = pin;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Didn't receive code? ",
                  style: AppFontStyle.body(color: Colors.white)),
              InkWell(
                onTap: () => controller.callResendOtpApi(),
                child: Text(
                  "Request again",
                  style:
                      AppFontStyle.body(color: AppColors.kPrimaryColor.value),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.h),
            child: Obx(
              () => CustomButton(
                width: double.maxFinite,
                linearColor: primaryButtonLinearColor,
                height: 35.h,
                borderRadius: 35.h / 2,
                isLoader: controller.apiLoading.value,
                style: AppFontStyle.body(color: Colors.white),
                text: 'Verify OTP',
                onTap: () {
                  if (controller.otp.value.length == 4) {
                    controller.calVerfyOtpApi();
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
