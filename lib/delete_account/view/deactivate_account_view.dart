import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/custom_button.dart';
import '../controller/deactivate_controller.dart';

class DeactivateAccountPage extends GetView<DeactivateAccountController> {
  const DeactivateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 40.w),
              child: Text(
                'Deactivate Account',
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: AppFontWeight.bold.value,
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.kPrimaryColor.value),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(left: 20.w, right: 20.w,top: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Reason",style: TextStyle(color: AppColors.kPrimaryColor.value,fontSize: 16.sp)),
              SizedBox(height: 20.h),
              Container(
                height: 150.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: controller.reasonController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Reason',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 50.h,
                margin: EdgeInsets.all(10),
                child: CustomButton(
                  width: double.maxFinite,
                  isLoader: controller.apiLoading.value,
                  linearColor: primaryButtonLinearColor,
                  height: 38.h,
                  borderRadius: 38.h / 2,
                  style: AppFontStyle.body(color: Colors.white),
                  text: 'Submit',
                  onTap: () {
                    if (controller.reasonController.text == "") {
                      Get.snackbar('Message', "Please Enter Reason",
                          backgroundColor:
                          AppColors.kGetSnackBarColor.value);
                    } else {
                    controller.showDialog();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
