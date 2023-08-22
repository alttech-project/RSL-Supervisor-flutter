import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:rsl_supervisor/location_queue/controllers/location_queue_controller.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/custom_app_container.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/navigation_title.dart';

class FareSelectionPage extends GetView<LocationQueueController> {
  const FareSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          controller.goBackfromFareSelection();
          return false;
        },
        child: Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: Colors.black,
          body: Obx(
            () => CommonAppContainer(
              showQrView: controller.showQrCode.value,
              qrData: controller.qrData.value,
              qrMessage: controller.qrMessage.value,
              hideQrAction: () {
                controller.showQrCode.value = false;
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10.w,
                    right: 10.w,
                    bottom: 12.h,
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        NavigationBarWithIcon(
                          onTap: () => controller.goBackfromFareSelection(),
                        ),
                        _formFields(
                          controller: controller.amountController,
                          hint: "Enter the amount",
                          lblTxt: "Amount",
                          keyboardtype: TextInputType.number,
                          onSubmit: (text) {},
                        ),
                        _formFields(
                          controller: controller.nameController,
                          hint: "Name (optional)",
                          lblTxt: "Name (optional)",
                          keyboardtype: TextInputType.name,
                          onSubmit: (text) {},
                        ),
                        _formFields(
                          controller: controller.emailController,
                          hint: "Email (optional)",
                          lblTxt: "Email (optional)",
                          keyboardtype: TextInputType.emailAddress,
                          onSubmit: (text) {
                            String email = text.trim();
                            if ((email.isNotEmpty) &&
                                !(GetUtils.isEmail(email))) {
                              return 'Please enter a valid Email ID';
                            }
                          },
                        ),
                        _formFields(
                          controller: controller.phoneController,
                          hint: "Phone number (optional)",
                          lblTxt: "Phone number (optional)",
                          keyboardtype: TextInputType.number,
                          onSubmit: (text) {},
                          isPhone: true,
                          onCountryChanged: (country) {
                            controller.countryCode.value = country.dialCode;
                          },
                        ),
                        _formFields(
                          controller: controller.messageController,
                          hint: "Message (optional)",
                          lblTxt: "Message (optional)",
                          keyboardtype: TextInputType.multiline,
                          onSubmit: (text) {},
                          maxLines: 3,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: ToggleButton(
                            width: ScreenUtil().screenWidth * 0.85,
                            height: 38.h,
                            toggleBackgroundColor: Colors.white,
                            toggleBorderColor: (Colors.grey[350])!,
                            toggleColor: AppColors.kPrimaryColor.value,
                            activeTextColor: Colors.white,
                            inactiveTextColor: Colors.grey,
                            leftDescription: 'Fixed Fare',
                            rightDescription: 'Meter Fare',
                            onLeftToggleActive: () {
                              controller.fixedMeter = 1;
                            },
                            onRightToggleActive: () {
                              controller.fixedMeter = 2;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Obx(
                          () => CustomButton(
                            width: double.maxFinite,
                            linearColor: primaryButtonLinearColor,
                            height: 38.h,
                            borderRadius: 38.h / 2,
                            isLoader: controller.showBtnLoader.value,
                            style: AppFontStyle.body(color: Colors.white),
                            text: 'Submit',
                            onTap: () => controller.submitAction(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formFields({
    required String hint,
    required String lblTxt,
    required TextInputType keyboardtype,
    required TextEditingController controller,
    required Function(String) onSubmit,
    bool isPhone = false,
    Function(Country)? onCountryChanged,
    int? maxLines,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isPhone ? 0 : 8.h),
      child: isPhone
          ? CountryCodeTextField(
              controller: controller,
              hint: hint,
              inputLblTxt: lblTxt,
              inputLblStyle: AppFontStyle.body(
                color: AppColors.kPrimaryColor.value,
              ),
              keyboardType: TextInputType.text,
              onSubmit: (value) {},
              textInputAction: TextInputAction.next,
              onCountryChanged: onCountryChanged,
            )
          : UnderlinedTextField(
              controller: controller,
              hint: hint,
              inputLblTxt: lblTxt,
              inputLblStyle: AppFontStyle.body(
                color: AppColors.kPrimaryColor.value,
              ),
              keyboardType: keyboardtype,
              onSubmit: onSubmit,
              maxLines: maxLines,
            ),
    );
  }
}
