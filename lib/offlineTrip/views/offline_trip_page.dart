import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
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
                            _labelAndTextFieldWidget(
                                'Fare', 'Fare', 'Enter Fare',
                                txtEditingController: controller.fareController,
                                keyboardType: TextInputType.number),
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

  Widget _searchCarWidget() {
    return Column(
      children: [
        Text(
          'Taxi List',
          style: AppFontStyle.subHeading(color: AppColors.kPrimaryColor.value),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: BoxTextField(
                hintText: "Search Car No",
                keyboardType: TextInputType.text,
                textController: controller.searchCarController,
                enable: true,
                autocorrect: false,
                suffix: IconButton(
                  onPressed: () {
                    controller.clearSearchedCarNumber();
                  },
                  icon: Icon(
                    Icons.clear_sharp,
                    size: 20.r,
                    color: AppColors.kPrimaryColor.value,
                  ),
                ),
                style: AppFontStyle.subHeading(
                    color: AppColors.kBlack.value,
                    size: AppFontSize.medium.value),
                onChanged: (value) => controller.filterCarNoResults(value),
                autofocus: false))
      ],
    );
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

  _taxiList() {
    return Expanded(
      child: Obx(
        () => controller.taxiList.isEmpty
            ? Center(
                child: SizedBox(
                  height: 280.h,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "No cars found!",
                            style: AppFontStyle.subHeading(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: controller.taxiList.length,
                itemBuilder: (context, index) {
                  final taxiData = controller.taxiList[index];
                  return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        controller.taxiId.value = '${taxiData.iId}';
                        controller.taxiModel.value = '${taxiData.taxiModel}';
                        controller.taxiNoController.text = '${taxiData.taxiNo}';
                      },
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 16),
                          //apply padding horizontal or vertical only
                          child: Text(
                            '${taxiData.taxiNo}',
                          )));
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.withOpacity(0.6),
                  thickness: 0.2,
                  height: 1,
                ),
              ),
      ),
    );
  }

  _showTaxiList() {
    controller.clearSearchedCarNumber();
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
        ),
        margin: EdgeInsets.only(top: 70.h),
        child: Column(
          children: [_line(), _searchCarWidget(), _taxiList()],
        ),
      ),
      isScrollControlled: true,
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
