import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/safe_area_container.dart';
import '../controllers/quick_trip_controller.dart';
import '../widgets/quick_trip_app_bar.dart';

class QuickTripPage extends GetView<QuickTripController> {
  const QuickTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        controller.onClose();
        return Future.value(true);
      },
      child: SafeAreaContainer(
        statusBarColor: Colors.black,
        themedark: true,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.w,
                right: 10.w,
                top: 24.h,
              ),
              child: Column(
                children: [
                  const QuickTripsAppBar(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _tripIdWidget(),
                          _dropLocationWidget(),
                          _labelAndTextFieldWidget(
                              'Fare', 'Fare', 'Enter Fare (Optional)',
                              txtEditingController: controller.fareController,
                              keyboardType: TextInputType.number),
                          _nameWidget(),
                          _phoneNumberWidget(),
                          _emailIdWidget(),
                          /*_labelAndTextFieldWidget(
                            'Payment ID',
                            'Payment ID',
                            'Enter Payment ID (Optional)',
                            txtEditingController:
                                controller.paymentIdController,
                            textInputAction: TextInputAction.done,
                          ),*/
                          SizedBox(
                            height: 24.h,
                          ),
                          Obx(
                            () => CustomButton(
                              width: double.maxFinite,
                              linearColor: primaryButtonLinearColor,
                              height: 38.h,
                              borderRadius: 38.h / 2,
                              isLoader: controller.apiLoading.value,
                              style: AppFontStyle.body(color: Colors.white),
                              text: 'Submit',
                              onTap: () => controller.checkValidation(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _labelAndTextFieldColumnWidget(
      String fieldLabel, String label, String hint,
      {Widget? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              fieldLabel,
              style:
                  AppFontStyle.subHeading(color: AppColors.kPrimaryColor.value),
            ),
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        CapsuleTextField(
          controller: controller.tripIdController,
          hint: hint,
          /*inputLblTxt: */ /*label*/ /*'',
          keyboardType: TextInputType.text,
          onSubmit: (value) {},*/
          suffix: suffix,
        ),
        SizedBox(
          height: 12.h,
        ),
      ],
    );
  }

  /*Widget _labelAndTextFieldWidget(String fieldLabel, String label, String hint,
      {Widget? suffix,
      required TextEditingController txtEditingController,
      TextInputType keyboardType = TextInputType.text,
      TextInputAction textInputAction = TextInputAction.next,
      FormFieldValidator? validator,
      bool readOnly = false,
      GestureTapCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: UnderlinedTextField(
        controller: txtEditingController,
        hint: hint,
        inputLblTxt: label,
        inputLblStyle: AppFontStyle.subHeading(
            color: AppColors.kPrimaryColor.value,
            size: AppFontSize.medium.value),
        keyboardType: keyboardType,
        onSubmit: (value) {},
        textInputAction: textInputAction,
        suffix: suffix,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }*/

  Widget _labelAndTextFieldWidget(String fieldLabel, String label, String hint,
      {Widget? suffix,
      required TextEditingController txtEditingController,
      TextInputType keyboardType = TextInputType.text,
      TextInputAction textInputAction = TextInputAction.next,
      FormFieldValidator? validator,
      bool readOnly = false,
      GestureTapCallback? onTap,
      Function(String)? onChanged,
      Color? borderColor,
      Color? focusColor,
      TextStyle? textStyle}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: UnderlinedTextField(
        controller: txtEditingController,
        hint: hint,
        inputLblTxt: label,
        inputLblStyle: AppFontStyle.subHeading(
            color: AppColors.kPrimaryColor.value,
            size: AppFontSize.medium.value),
        keyboardType: keyboardType,
        onSubmit: (value) {},
        textInputAction: textInputAction,
        suffix: suffix,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        borderColor: borderColor,
        focusColor: focusColor,
        textStyle: textStyle,
      ),
    );
  }

  Widget _phoneNumberWidget() {
    return CountryCodeTextField(
      controller: controller.phoneController,
      hint: 'Phone Number (Optional)',
      inputLblTxt: 'Phone Number',
      inputLblStyle: AppFontStyle.subHeading(
          color: AppColors.kPrimaryColor.value, size: AppFontSize.medium.value),
      keyboardType: TextInputType.text,
      onSubmit: (value) {},
      textInputAction: TextInputAction.next,
      onCountryChanged: (country) {
        controller.countryCode.value = country.dialCode;
      },
    );
  }

  Widget _emailIdWidget() {
    return _labelAndTextFieldWidget(
      'Email Id',
      'Email Id',
      'Enter Email (Optional)',
      txtEditingController: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        if (GetUtils.isEmail(value)) {
          return null;
        } else {
          return 'Please enter a valid Email ID';
        }
      },
    );
  }

  Widget _nameWidget() {
    return _labelAndTextFieldWidget('Name', 'Name', 'Enter Name (Optional)',
        txtEditingController: controller.nameController, validator: (value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      if (GetUtils.isUsername(value)) {
        return null;
      } else {
        return 'Please enter a valid Name';
      }
    });
  }

  Widget _dropLocationWidget() {
    return _labelAndTextFieldWidget(
        'Drop Location', 'Drop Location', 'Enter Drop Location',
        txtEditingController: controller.dropLocationController,
        readOnly: true,
        onTap: () => controller.navigateToPlaceSearchPage(),
        /*Get.back()*/
        suffix: IconButton(
          onPressed: () => controller.clearDropLocation(),
          icon: Icon(
            Icons.clear_sharp,
            size: 20.r,
            color: AppColors.kPrimaryColor.value,
          ),
        ),
        validator: (value) {
          /*  if (value == null || value.isEmpty) {
            return 'Please select a valid Drop Location!';
          }*/
          return null;
        });
  }

  Widget _tripIdWidget() {
    return _labelAndTextFieldWidget(
      'Trip Id',
      'Trip Id',
      'Enter Trip Id',
      txtEditingController: controller.tripIdController,
      suffix: IconButton(
        onPressed: () => controller.clearTripId(),
        icon: Icon(
          Icons.clear_sharp,
          size: 20.r,
          color: AppColors.kPrimaryColor.value,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
