import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/custom_button.dart';
import '../controller/signup_controller.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.kBlack.value,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text(
            "Supervisor SignUp",
            style: AppFontStyle.heading(
              color: AppColors.kPrimaryColor.value,
            ),
          ),
          backgroundColor: AppColors.kBlack.value,
          elevation: 0,
        ),
        body: SafeArea(
          child: _signUpWidget(),
        ),
      ),
    );
  }



  Widget _signUpWidget() {
    return SingleChildScrollView(child:Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            children: [
              _nameWidget(),
              _emailWidget(),
              _phoneNumberWidget(),
              _uniqueNumberWidget(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.w,right: 10.w,bottom: 10.h),
          child: _submitBtnWidget(),
        ),
      ],
    )
    );
  }


  Widget _nameWidget() {
    return _labelAndTextFieldWidget(
      'Name', 'Name', 'Name',50,
      txtEditingController: controller.nameController,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter guest name';
        }
        return null;
      },
    );
  }

  Widget _emailWidget() {
    return _labelAndTextFieldWidget(
      'Email', 'Email', 'Enter your email',50,
      txtEditingController: controller.emailController,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter email';
        }
        return null;
      },
    );
  }

  Widget _phoneNumberWidget() {
    return _labelAndTextFieldWidget(
      'Phone Number', 'Phone Number', 'Enter your Phone Number',9,
      txtEditingController: controller.phoneNumberController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter phone number';
        }
        return null;
      },
    );
  }

  Widget _uniqueNumberWidget() {
    return _labelAndTextFieldWidget(
      'Unique Id', 'Unique Id', 'Enter your Unique Id',10,
      txtEditingController: controller.uniqueNumberController,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter unique number';
        }
        return null;
      },
    );
  }

  Widget _submitBtnWidget() {
    return Obx(() => CustomButton(
      onTap: () {
        controller.checkValidation();
        // Submit button action
      },
      isLoader: controller.apiLoading.value,
      text: "Submit",
      style: AppFontStyle.body(
        size: AppFontSize.small.value,
        color: Colors.white,
        weight: AppFontWeight.semibold.value,
      ),
    ),
    );
  }

  Widget _labelAndTextFieldWidget(
      String fieldLabel,
      String label,
      String hint,
       int maxLength,

      {
        Widget? suffix,
        required TextEditingController txtEditingController,
        TextInputType keyboardType = TextInputType.text,
        TextInputAction textInputAction = TextInputAction.next,
        FormFieldValidator? validator,
        bool readOnly = false,
        GestureTapCallback? onTap,
        Function(String)? onChanged,
        Color? borderColor,
        Color? focusColor,
        TextStyle? textStyle,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: UnderlinedTextField(
        controller: txtEditingController,
        hint: hint,
        maxLength: maxLength,
        inputLblTxt: label,
        inputLblStyle: AppFontStyle.subHeading(
          color: AppColors.kPrimaryColor.value,
          size: AppFontSize.medium.value,
        ),
        keyboardType: keyboardType,
        onSubmit: (value) {},
        textInputAction: textInputAction,
        suffix: suffix,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        borderColor: AppColors.kLightTextSecondary.value,
        focusColor: focusColor,
        textStyle: textStyle,
      ),
    );
  }
}
