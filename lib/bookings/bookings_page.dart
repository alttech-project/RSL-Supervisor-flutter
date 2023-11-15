import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/bookings/controller/bookings_controller.dart';
import 'package:rsl_supervisor/bookings/views/bookings_app_bar.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/safe_area_container.dart';

class BookingsPage extends GetView<BookingsController> {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
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
                    const BookingsAppBar(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _nameWidget(),
                            _phoneNumberWidget(),
                            _emailIdWidget(),
                            _pickUpLocationWidget(),
                            _dropLocationWidget(),
                            _selectCarModelWidget(),
                            /* _labelAndTextFieldWidget(
                                'Fare', 'Fare', 'Enter Fare',
                                txtEditingController: controller.fareController,
                                keyboardType: TextInputType.number),*/
                            _labelAndTextFieldWidget(
                                'Date', 'Date', 'Select Date',
                                onTap: () => _selectDateTime(context),
                                txtEditingController: controller.dateController,
                                textInputAction: TextInputAction.done,
                                readOnly: true,
                                suffix: IconButton(
                                  onPressed: () => _selectDateTime(context),
                                  icon: Icon(
                                    Icons.calendar_today,
                                    size: 20.r,
                                    color: AppColors.kPrimaryColor.value,
                                  ),
                                )),
                            SizedBox(
                              height: 24.h,
                            ),
                            Obx(
                                  () =>
                                  CustomButton(
                                    width: double.maxFinite,
                                    linearColor: primaryButtonLinearColor,
                                    height: 38.h,
                                    borderRadius: 38.h / 2,
                                    isLoader: controller.apiLoading.value,
                                    style: AppFontStyle.body(
                                        color: Colors.white),
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
            return 'Please enter a valid Name';
          } else {
            return null;
          }
        });
  }

  Widget _pickUpLocationWidget() {
    return _labelAndTextFieldWidget(
        'Pickup Location', 'Pickup Location', 'Enter Pickup Location',
        txtEditingController: controller.pickupLocationController,
        readOnly: true,
        onTap: () => controller.navigateToPickUpPlaceSearchPage(),
        suffix: IconButton(
          onPressed: () => controller.clearPickUpLocation(),
          icon: Icon(
            Icons.clear_sharp,
            size: 20.r,
            color: AppColors.kPrimaryColor.value,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a valid pickup Location!';
          }
          return null;
        });
  }

  Widget _dropLocationWidget() {
    return _labelAndTextFieldWidget(
        'Drop Location', 'Drop Location', 'Enter Drop Location',
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
          /*  if (value == null || value.isEmpty) {
            return 'Please select a valid Drop Location!';
          }*/
          return null;
        });
  }

  Widget _selectCarModelWidget() {
    return _labelAndTextFieldWidget(
        'Select car model', 'Select car model', 'Select car model',
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
            return 'Please select a car!';
          }
          return null;
        });
  }

  Widget _line() {
    return Container(
      width: 40.w,
      height: 3.h,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5.r),
      ),
    );
  }

  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    // ignore: unnecessary_null_comparison
    if (date == null) return;

    final time = await _selectTime(context);
    // ignore: unnecessary_null_comparison
    if (time == null) return;

    controller.dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    controller.getDate();
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: controller.dateTime.subtract(const Duration(days: 62)),
      lastDate: controller.dateTime,
    );
    if (selected != null && selected != controller.selectedDate) {
      controller.selectedDate = selected;
    }
    return controller.selectedDate;
  }

// Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: controller.selectedTime,
    );
    if (selected != null && selected != controller.selectedTime) {
      controller.selectedTime = selected;
    }
    return controller.selectedTime;
  }
}
