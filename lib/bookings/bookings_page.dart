import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsl_supervisor/bookings/controller/bookings_controller.dart';
import 'package:rsl_supervisor/bookings/views/bookings_app_bar.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/safe_area_container.dart';
import '../widgets/navigation_title.dart';

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
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: NavigationTitle(
                        title: "Bookings",
                        onTap: () => controller.goBack(),
                      ),
                    ),
                    DefaultTabController(
                      length: 3,
                      initialIndex: controller.selectedTabBar.value,
                      child: Column(
                        children: [
                          _tabBarWidget(tabs: [
                            _tabBarTextWidget(text: "New Booking"),
                            _tabBarTextWidget(text: "Ongoing Booking"),
                            _tabBarTextWidget(text: "Completed Trips"),
                          ]),
                          SizedBox(
                            height: 5.h,
                          ),
                          Obx(() => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: _tabView(
                                    controller.selectedTabBar.value, context),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  TabBar _tabBarWidget({required List<Widget> tabs}) {
    return TabBar(
        isScrollable: true,
        onTap: (value) => controller.changeTabIndex(value),
        controller: controller.tabController,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: AppColors.kPrimaryColor.value,
        labelColor: AppColors.kPrimaryColor.value,
        unselectedLabelColor: AppColors.kBackGroundColor.value,
        tabs: tabs);
  }

  Widget _tabView(int value, context) {
    switch (value) {
      case 0:
        return newBookingWidget(context);
      case 1:
        return newBookingWidget(context);
      case 2:
        return newBookingWidget(context);
    }
    return const SizedBox.shrink();
  }

  _tabBarTextWidget({String? text}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Text("${text}",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                    textStyle: TextStyle(
                        fontSize: AppFontSize.medium.value,
                        fontWeight: AppFontWeight.semibold.value))),
          ],
        ),
      );

  Widget newBookingWidget(context) {
    return Column(
      children: [
        _personalInfo(context),
        SizedBox(height: 10.h),
        _locationInfo(context),
        SizedBox(height: 10.h),
        _customPricingInfo(context),
        SizedBox(height: 10.h),
        _additionalElementsInfo(context),
        SizedBox(height: 24.h),
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
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _personalInfo(context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      color: AppColors.kPrimaryTransparentColor.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 8,
        ), // Adjust left and right padding
        child: Column(children: [
          _nameWidget(),
          _phoneNumberWidget(),
          _emailIdWidget(),
        ]),
      ),
    );
  }

  Widget _locationInfo(context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      color: AppColors.kPrimaryTransparentColor.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 8,
        ), // Adjust left and right padding
        child: Column(children: [
          _pickUpLocationWidget(),
          _dropLocationWidget(),
          _labelAndTextFieldWidget('Date', 'Date', 'Select Date',
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
          _selectCarModelWidget(),
          _paymentDropDown(
            selectedOption: controller.selectedPaymentMethod.value,
            onTap: (value) {
              controller.selectedPaymentMethod.value = value;
            },
          ),
        ]),
      ),
    );
  }

  Widget _customPricingInfo(context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      color: AppColors.kPrimaryTransparentColor.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 8,
        ), // Adjust left and right padding
        child: Column(children: [
          _labelCustomPricing(),
          _layoutCustomPricing(),
        ]),
      ),
    );
  }

  Widget _additionalElementsInfo(context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      color: AppColors.kPrimaryTransparentColor.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 8,
        ), // Adjust left and right padding
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _labelAdditionalElements(),
          _layoutAdditionalElements()
        ]),
      ),
    );
  }

  Widget _paymentDropDown(
      {required String? selectedOption,
      required Function(String value) onTap}) {
    return Container(
      height: 50.h,
      /* decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColors.kWhite.value, width: 1.0)),
      )*/
      child: DropdownButton<String>(
        value: selectedOption,
        isExpanded: true,
        alignment: Alignment.center,
        onChanged: (newValue) {
          onTap(newValue ?? "");
        },
        items: <String>[
          'Select Payment Method',
          'Cash',
          'Bill',
          'Complimentary'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            onTap: () {
              onTap(value);
            },
            value: value,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Text(
                value,
                style: GoogleFonts.outfit(
                  textStyle: TextStyle(
                      fontSize: AppFontSize.medium.value,
                      fontWeight: AppFontWeight.semibold.value,
                      color: AppColors.kPrimaryColor.value),
                ),
              ),
            ),
          );
        }).toList(),
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

  Widget _nameWidget() {
    return _labelAndTextFieldWidget(
        'Guest Name', 'Guest Name', 'Enter Guest Name (Optional)',
        txtEditingController: controller.nameController, validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a valid guest name';
      } else {
        return null;
      }
    });
  }

  Widget _phoneNumberWidget() {
    return CountryCodeTextField(
      controller: controller.phoneController,
      hint: 'Guest Phone Number (Optional)',
      inputLblTxt: 'Guest Phone Number',
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
      'Guest Email Id',
      'Guest Email Id',
      'Guest Enter Email (Optional)',
      txtEditingController: controller.emailController,
      textInputAction: TextInputAction.next,
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
        'Select Car Model', 'Select Car Model', 'Select Car Model',
        txtEditingController: controller.carModelController,
        readOnly: true,
        onTap: () => controller.showCustomDialog(Get.context!),
        suffix: IconButton(
          onPressed: () => controller.clearCarModel(),
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

  Widget _priceWidget() {
    return BoxTextFieldTransparent(
        hintText: "Price",
        keyboardType: TextInputType.number,
        textController: controller.priceController,
        enable: true,
        autocorrect: false,
        // onChanged: (value) => controller.priceController.text = value,
        autofocus: false);
  }

  Widget _extraChargesWidget() {
    return BoxTextFieldTransparent(
        hintText: "Extra Charges",
        keyboardType: TextInputType.number,
        textController: controller.extraChargesController,
        enable: true,
        autocorrect: false,
        // onChanged: (value) => controller.extraChargesController.text = value,
        autofocus: false);
  }

  Widget _noteToDriverWidget() {
    return _labelAndTextFieldWidget(
      'Note to Driver',
      'Note to Driver',
      'Enter Note to Driver (Optional)',
      txtEditingController: controller.noteToDriverController,
      keyboardType: TextInputType.text,
      validator: (value) {
        return null;
      },
    );
  }

  Widget _noteToAdminWidget() {
    return _labelAndTextFieldWidget(
        'Note to Admin', 'Note to Admin', 'Enter Note to Admin (Optional)',
        txtEditingController: controller.noteToAdminController,
        keyboardType: TextInputType.text, validator: (value) {
      return null;
    });
  }

  Widget _flightNumberWidget() {
    return _labelAndTextFieldWidget(
        'Flight Number', 'Flight Number', 'Enter Flight Number (Optional)',
        txtEditingController: controller.flightNumberController,
        keyboardType: TextInputType.number, validator: (value) {
      return null;
    });
  }

  Widget _refNumberWidget() {
    return _labelAndTextFieldWidget('Reference Number', 'Reference Number',
        'Enter Reference Number (Optional)',
        txtEditingController: controller.refNumberController,
        keyboardType: TextInputType.number, validator: (value) {
      return null;
    });
  }

  Widget _remarksLabel() {
    return Text(
      'Remarks',
      style: AppFontStyle.subHeading(
        size: AppFontSize.medium.value,
        color: AppColors.kPrimaryColor.value,
      ),
      textAlign: TextAlign.start,
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
    return BoxTextFieldTransparent(
        hintText: "Remarks",
        keyboardType: TextInputType.number,
        textController: controller.remarksController,
        enable: true,
        autocorrect: false,
        // onChanged: (value) => controller.remarksController.text = value,
        autofocus: false);
  }

  Widget _labelCustomPricing() {
    return Row(
      children: [
        Expanded(
            child: Text(
          'Custom Pricing',
          style: AppFontStyle.subHeading(
            size: AppFontSize.medium.value,
            color: AppColors.kPrimaryColor.value,
          ),
          textAlign: TextAlign.start,
        )),
        Obx(() => InkWell(
              onTap: () => {
                if (controller.showCustomPricing.value)
                  controller.showCustomPricing.value = false
                else
                  controller.showCustomPricing.value = true
              },
              child: Icon(
                controller.showCustomPricing.value
                    ? Icons.arrow_drop_up_sharp
                    : Icons.arrow_drop_down_sharp,
                size: 20.r,
                color: AppColors.kPrimaryColor.value,
              ),
            ))
      ],
    );
  }

  Widget _layoutCustomPricing() {
    return Obx(() => controller.showCustomPricing.value
        ? Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
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
                        child: Expanded(child: _priceWidget())),
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
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
                        child: Expanded(child: _extraChargesWidget())),
                  )),
                ],
              )
            ],
          )
        : const SizedBox.shrink());
  }

  Widget _labelAdditionalElements() {
    return Row(
      children: [
        Expanded(
            child: Text(
          'Additional Elements',
          style: AppFontStyle.subHeading(
            size: AppFontSize.medium.value,
            color: AppColors.kPrimaryColor.value,
          ),
          textAlign: TextAlign.start,
        )),
        Obx(() => InkWell(
              onTap: () => {
                if (controller.showAdditionalElements.value)
                  controller.showAdditionalElements.value = false
                else
                  controller.showAdditionalElements.value = true
              },
              child: Icon(
                controller.showAdditionalElements.value
                    ? Icons.arrow_drop_up_sharp
                    : Icons.arrow_drop_down_sharp,
                size: 20.r,
                color: AppColors.kPrimaryColor.value,
              ),
            ))
      ],
    );
  }

  Widget _layoutAdditionalElements() {
    return Obx(() => controller.showAdditionalElements.value
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              _noteToDriverWidget(),
              _noteToAdminWidget(),
              _flightNumberWidget(),
              _refNumberWidget(),
              SizedBox(height: 10.h),
              _remarksLabel(),
              SizedBox(height: 7.h),
              _remarksCardView(),
            ],
          )
        : const SizedBox.shrink());
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
