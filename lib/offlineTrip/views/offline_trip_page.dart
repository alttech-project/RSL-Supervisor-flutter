import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/safe_area_container.dart';
import '../controllers/offline_trip_controller.dart';
import 'offline_trip_appbar.dart';

class OfflineTripPage extends GetView<OfflineTripController> {
  const OfflineTripPage({super.key});

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
                  const OfflineTripsAppBar(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _taxiNoWidget(),
                          _dropLocationWidget(),
                          _labelAndTextFieldWidget('Fare', 'Fixed Fare',
                              'Enter Fixed Fare (Optional)',
                              txtEditingController: controller.fareController,
                              keyboardType: TextInputType.number),
                          _labelAndTextFieldWidget(
                            'Date',
                            'Date',
                            'Select Date',
                            txtEditingController: controller.dateController,
                            textInputAction: TextInputAction.done,
                          ),
                          _nameWidget(),
                          _phoneNumberWidget(),
                          _emailIdWidget(),
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

  Widget _labelAndTextFieldWidget(String fieldLabel, String label, String hint,
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
        'Drop Location', 'Drop Location', 'Enter Trip Id',
        txtEditingController: controller.dropLocationController,
        readOnly: true,
        onTap: () => controller.navigateToPlaceSearchPage(),
        suffix: IconButton(
          onPressed: () => controller.clearDropLocation(),
          icon: Icon(
            Icons.clear_sharp,
            size: 20.r,
            color: AppColors.kPrimaryColor.value,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a valid Drop Location!';
          }
          return null;
        });
  }

  Widget _taxiNoWidget() {
    return _labelAndTextFieldWidget(
      'Car No',
      'Car No',
      'Enter Car No',
      txtEditingController: controller.taxiNoController,
      readOnly: true,
      onTap: () => _showTaxiList(),
      suffix: IconButton(
        onPressed: () => controller.clearTaxiNumber(),
        icon: Icon(
          Icons.clear_sharp,
          size: 20.r,
          color: AppColors.kPrimaryColor.value,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  _showTaxiList() {
    /*Get.bottomSheet(
    ,
    barrierColor: Colors.red[50],
    isDismissible: false,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(35),
    side: const BorderSide(
    width: 1,
    color: Colors.black,
    ),
    ),
    enableDrag: true,
    backgroundColor: Colors.transparent,

    );*/

    showModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return Container(
          height: 150,
          color: Colors.greenAccent,
          child: ListView.separated(
            itemCount: controller.taxiList.length,
            itemBuilder: (context, index) {
              final taxiData = controller.taxiList[index];
              return Text('${taxiData.taxiNo}');
            },
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.withOpacity(0.6),
              thickness: 1,
              height: 5,
            ),
          ),
        );
      },
    );
  }
}
