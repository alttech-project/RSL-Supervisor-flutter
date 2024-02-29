import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bookings/data/motor_details_data.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../network/app_config.dart';
import '../../routes/app_routes.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../utils/helpers/getx_storage.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/safe_area_container.dart';
import '../controllers/quick_trip_controller.dart';
import '../widgets/quick_trip_app_bar.dart';

class QuickTripPage extends GetView<QuickTripController> {
  const QuickTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode discountFocusNode = FocusNode();
    discountFocusNode.addListener(() {
      if (discountFocusNode.hasFocus) {
        controller.originalFare = controller.fareController.text.trim();
      }
    });
    return WillPopScope(
      onWillPop: () {
        final DashBoardController dashBoardController =
            Get.find<DashBoardController>();
        dashBoardController.startTimer();
        controller.onClose();
        return Future.value(true);
      },
      child: SafeAreaContainer(
        statusBarColor: Colors.black,
        themedark: true,
        child: Obx(
          () => Scaffold(
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
                            controller.pageType.value == 1
                                ? _dropLocationWidget()
                                : _dropLocationWidgetHotelBooking(),
                            controller.pageType.value == 1 ||
                                    controller.enableEditFare.value == 1
                                ? _labelAndTextFieldWidget(
                                    'Fare', 'Fare', 'Enter Fare (Optional)',
                                    txtEditingController:
                                        controller.fareController,
                                    onSubmitted: (value) =>
                                        controller.originalFare = value,
                                    keyboardType: TextInputType.number)
                                : _labelAndTextFieldWidget(
                                    'Fare', 'Fare', 'Enter Fare',
                                    txtEditingController:
                                        controller.fareController,
                                    onSubmitted: (value) =>
                                        controller.originalFare = value,
                                    readOnly: true,
                                    keyboardType: TextInputType.number),
                            controller.locationType.value ==
                                    LocationType.GENERAL.toString()
                                ? const SizedBox.shrink()
                                : _labelAndTextFieldWidget(
                                    'Discount',
                                    'Discount',
                                    'Enter Discount (Optional)',
                                    txtEditingController:
                                        controller.customPriceController,
                                    focusNode: discountFocusNode,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) =>
                                        controller.updateFare(value),
                                  ),
                            _labelPaymentOptionInfo(),
                            _nameWidget(),
                            _phoneNumberWidget(),
                            _emailIdWidget(),
                            _labelAndTextFieldWidget(
                                'Reference Number',
                                'Reference Number',
                                'Reference Number (Optional)',
                                txtEditingController:
                                    controller.referenceNumberController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next),
                            /*_labelAndTextFieldWidget(
                            'Payment ID',
                            'Payment ID',
                            'Enter Payment ID (Optional)',
                            txtEditingController:
                                controller.paymentIdController,
                            textInputAction: TextInputAction.done,
                          ),*/
                            SizedBox(height: 10.h),
                            _remarksLabel(),
                            SizedBox(height: 7.h),
                            _remarksCardView(),
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
                            SizedBox(
                              height: 20.h,
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
      ),
    );
  }

  Widget _remarksLabel() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        'Remarks',
        style: AppFontStyle.subHeading(
          size: AppFontSize.medium.value,
          color: AppColors.kPrimaryColor.value,
        ),
      ),
    );
  }

  Widget _remarksCardView() {
    return SizedBox(
      height: 100.h,
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        color: AppColors.kSecondaryBackGroundColor.value,
        child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5,
            ), // Adjust left and right padding
            child: _remarksWidget()),
      ),
    );
  }

  Widget _remarksWidget() {
    return RemarksTextFieldTransparent(
        hintText: "Enter your remarks (optional)",
        keyboardType: TextInputType.multiline,
        textController: controller.remarksController,
        enable: true,
        autocorrect: false,
        textInputAction: TextInputAction.newline,
        autofocus: false);
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
      final FocusNode? focusNode,
      required TextEditingController txtEditingController,
      TextInputType keyboardType = TextInputType.text,
      TextInputAction textInputAction = TextInputAction.next,
      FormFieldValidator? validator,
      bool readOnly = false,
      GestureTapCallback? onTap,
      Function(String)? onChanged,
      Function(String)? onSubmitted,
      Color? borderColor,
      Color? focusColor,
      TextStyle? textStyle}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: UnderlinedTextField(
        controller: txtEditingController,
        focusNode: focusNode,
        hint: hint,
        inputLblTxt: label,
        inputLblStyle: AppFontStyle.subHeading(
            color: AppColors.kPrimaryColor.value,
            size: AppFontSize.medium.value),
        keyboardType: keyboardType,
        // onSubmit: (value) {},
        textInputAction: textInputAction,
        suffix: suffix,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        onSubmit: onSubmitted,
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
      textInputAction: TextInputAction.next,
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
      return null;
      /*  if (value == null || value.isEmpty) {
        return null;
      }
      if (GetUtils.isUsername(value.trim())) {
        return null;
      } else {
        return 'Please enter a valid Name';
      }*/
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

  Widget _dropLocationWidgetHotelBooking() {
    return _labelAndTextFieldWidget(
        'Drop Location', 'Drop Location', 'Enter Drop Location',
        txtEditingController: controller.dropLocationController, readOnly: true,
        /* suffix: IconButton(
          onPressed: () => controller.clearDropLocation(),
          icon: Icon(
            Icons.clear_sharp,
            size: 20.r,
            color: AppColors.kPrimaryColor.value,
          ),
        ),*/
        validator: (value) {
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

  Widget _labelPaymentOptionInfo() {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          _labelPaymentOption(),
          const SizedBox(
            height: 8,
          ),
          _selectedPaymentOption()
        ],
      ),
    );
  }

  Widget _labelPaymentOption() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        'Payment Option',
        style: AppFontStyle.subHeading(
          size: AppFontSize.medium.value,
          color: AppColors.kPrimaryColor.value,
        ),
      ),
    );
  }

  Widget _selectedPaymentOption() {
    return Obx(
      () => SizedBox(
        width: double.maxFinite,
        height: 57,
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          color: AppColors.kSecondaryBackGroundColor.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 10,
            ), // Adjust left and right padding
            child: Row(
              children: [
                Expanded(
                  child: _paymentDropDown(
                    selectedOption: controller.selectedPayment.value,
                    onTap: (value) {
                      controller.selectedPayment.value = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentDropDown(
      {required Payments? selectedOption,
      required Function(Payments value) onTap}) {
    return SizedBox(
      child: DropdownButton<Payments>(
        value: selectedOption,
        isExpanded: true,
        underline: Container(
          height: 1.0,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide.none),
          ),
        ),
        icon: Icon(
          Icons.arrow_drop_down_sharp,
          size: 20.r,
          color: AppColors.kPrimaryColor.value,
        ),
        dropdownColor: Colors.black,
        iconDisabledColor: AppColors.kPrimaryColor.value,
        iconEnabledColor: AppColors.kPrimaryColor.value,
        alignment: Alignment.center,
        onChanged: (newValue) {
          onTap(newValue!);
        },
        items: quickTripsPaymentList
            .map<DropdownMenuItem<Payments>>((Payments value) {
          return DropdownMenuItem<Payments>(
            onTap: () {
              onTap(value);
            },
            value: value,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Text(
                value.name.toString(),
                style: GoogleFonts.outfit(
                  textStyle: TextStyle(
                      fontSize: AppFontSize.verySmall.value,
                      fontWeight: AppFontWeight.normal.value,
                      color: Colors.white),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
