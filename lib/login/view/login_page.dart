import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/login/widgets/email_input_widget.dart';
import 'package:rsl_supervisor/login/widgets/verify_otp_widget.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';

import '../controller/login_controller.dart';
import '../../widgets/safe_area_container.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.onBackPressed();
        return true;
      },
      child: Obx(
        () => SafeAreaContainer(
          statusBarColor: Colors.black,
          themedark: true,
          child: Scaffold(
            backgroundColor: AppColors.kBlack.value,
            extendBodyBehindAppBar: true,
            body: SafeArea(
                minimum: EdgeInsets.symmetric(horizontal: 15.w),
                child: (controller.currentView.value == LoginViews.emailPage)
                    ? const EmailInputWidget()
                    : const VerifyOTPWidget()),
          ),
        ),
      ),
    );
  }
}
