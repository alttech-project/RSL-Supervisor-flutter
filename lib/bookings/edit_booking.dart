import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsl_supervisor/bookings/data/motor_details_data.dart';
import 'package:rsl_supervisor/utils/helpers/alert_helpers.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';
import 'package:rsl_supervisor/widgets/custom_app_container.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/safe_area_container.dart';
import '../widgets/app_loader.dart';
import '../widgets/navigation_title.dart';
import 'controller/edit_booking_controller.dart';

class EditBooking extends GetView<EditBookingController> {
  const EditBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          if (!controller.isValueChanged.value) {
            controller.goBack();
            controller.onClose();
            return Future.value(true);
          } else {
            showDefaultDialog(
                context: Get.context!,
                title: "Alert",
                message: "Do you want to save this details?",
                isTwoButton: true,
                acceptBtnTitle: "Yes",
                acceptAction: () {
                  controller.callEditBookingApi();
                },
                cancelBtnTitle: "No",
                cancelAction: () {
                  controller.goBackPage();
                });
            return Future.value(false);
          }
        },
        child: SafeAreaContainer(
          statusBarColor: Colors.black,
          themedark: true,
          child: Scaffold(
            extendBodyBehindAppBar: false,
            backgroundColor: Colors.black,
            body: Obx(() => controller.apiLoading.value
                ? const Center(
                    child: AppLoader(),
                  )
                : CommonAppContainer(
                    showLoader: controller.apiLoading.value,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          //Fill the code of padding
                          Padding(
                            padding: EdgeInsets.only(
                                left: 22.w, right: 22.w, top: 5.h),
                            child: NavigationTitle(
                              title: "Edit Bookings",
                              onTap: () {
                                if (!controller.isValueChanged.value) {
                                  controller.goBack();
                                } else {
                                  showDefaultDialog(
                                      context: Get.context!,
                                      title: "Alert",
                                      message:
                                          "Do you want to save this details?",
                                      isTwoButton: true,
                                      acceptBtnTitle: "Yes",
                                      acceptAction: () {
                                        controller.callEditBookingApi();
                                      },
                                      cancelBtnTitle: "No",
                                      cancelAction: () {
                                        controller.goBackPage();
                                      });
                                }
                              },
                            ),
                          ),
                          newBookingsTab(context),
                        ],
                      ),
                    ),
                  )),
          ),
        ),
      ),
    );
  }

  Widget newBookingsTab(context) {
    return Column(
      children: [
        _personalInfo(context),
        SizedBox(height: 10.h),
        _locationInfo(context),
        SizedBox(height: 10.h),
        _carModelInfo(),
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
            isLoader: controller.saveBookingApiLoading.value,
            style: AppFontStyle.body(color: Colors.white),
            text: 'Update',
            onTap: () => controller.checkNewBookingValidation(),
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
          /*_selectCarModelWidget(),
          _paymentDropDown(
            selectedOption: controller.selectedPaymentMethod.value,
            onTap: (value) {
              controller.selectedPaymentMethod.value = value;
            },
          ),*/
        ]),
      ),
    );
  }

  Widget _carModelInfo() {
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
        child: Row(children: [
          _layoutCarModelInfo(),
          const SizedBox(
            width: 20,
          ),
          _labelPaymentOptionInfo()
        ]),
      ),
    );
  }

  Widget _layoutCarModelInfo() {
    return Expanded(
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            _labelCarModel(),
            const SizedBox(
              height: 8,
            ),
            _selectedCarModel()
          ],
        ),
      ),
    );
  }

  Widget _labelPaymentOptionInfo() {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            _labelPaymentOption(),
            const SizedBox(
              height: 8,
            ),
            _selectedPaymentOption()
          ],
        ),
      ),
    );
  }

  Widget _labelCarModel() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        'Car Model',
        style: AppFontStyle.subHeading(
          size: AppFontSize.medium.value,
          color: AppColors.kPrimaryColor.value,
        ),
      ),
    );
  }

  Widget _selectedCarModel() {
    return SizedBox(
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
                  child: InkWell(
                    onTap: () => controller.showCustomDialog(Get.context!),
                    child: Text(
                      controller.taxiModel.value,
                      style: AppFontStyle.normalText(
                        size: AppFontSize.verySmall.value,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => controller.showCustomDialog(Get.context!),
                  child: Icon(
                    Icons.arrow_drop_down_sharp,
                    size: 20.r,
                    color: AppColors.kPrimaryColor.value,
                  ),
                ),
              ],
            ),
          )),
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
    return SizedBox(
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
                    controller.isValueChanged.value = true;
                    controller.selectedPayment.value = value;
                  },
                ),
              ),
            ],
          ),
        ),
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
        items: paymentList.map<DropdownMenuItem<Payments>>((Payments value) {
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
        borderColor: AppColors.kLightTextSecondary.value,
        focusColor: focusColor,
        textStyle: textStyle,
      ),
    );
  }

  Widget _nameWidget() {
    return _labelAndTextFieldWidget(
        'Guest Name', 'Guest Name', 'Enter Guest Name',
        txtEditingController: controller.nameController,
        onChanged: (val) {
          controller.isValueChanged.value = true;
        },
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter guest name';
          }
          return null;
        });
  }

  Widget _phoneNumberWidget() {
    return Obx(
      () => CountryCodeTextField(
        controller: controller.phoneController,
        hint: 'Guest Phone Number',
        inputLblTxt: 'Guest Phone Number',
        initialCountryCode: controller.initialCountryCode.value,
        inputLblStyle: AppFontStyle.subHeading(
            color: AppColors.kPrimaryColor.value,
            size: AppFontSize.medium.value),
        textInputAction: TextInputAction.next,
        onCountryChanged: (country) {
          controller.isValueChanged.value = true;
          controller.countryCode.value = country.dialCode;
        },
      ),
    );
  }

  Widget _emailIdWidget() {
    return _labelAndTextFieldWidget(
      'Guest Email',
      'Guest Email',
      'Enter Guest Email',
      onChanged: (val) {
        controller.isValueChanged.value = true;
      },
      txtEditingController: controller.emailController,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter email";
        }
        if (GetUtils.isEmail(value)) {
          return null;
        } else {
          return 'Please enter valid email';
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
        onChanged: (val) {
          controller.isValueChanged.value = true;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select pickup location!';
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
        onChanged: (val) {
          controller.isValueChanged.value = true;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select drop location!';
          }
          return null;
        });
  }

  /* Widget _selectCarModelWidget() {
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
  }*/

  Widget _priceWidget() {
    return BoxTextFieldTransparent(
        hintText: "Price",
        keyboardType: TextInputType.number,
        textController: controller.priceController,
        enable: true,
        autocorrect: false,
        textInputAction: TextInputAction.next,
        onChanged: (val) {
          controller.isValueChanged.value = true;
        },
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
        textInputAction: TextInputAction.done,
        onChanged: (val) {
          controller.isValueChanged.value = true;
        },
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
      onChanged: (val) {
        controller.isValueChanged.value = true;
      },
      validator: (value) {
        return null;
      },
    );
  }

  Widget _noteToAdminWidget() {
    return _labelAndTextFieldWidget(
        'Note to Admin', 'Note to Admin', 'Enter Note to Admin (Optional)',
        txtEditingController: controller.noteToAdminController,
        onChanged: (val) {
          controller.isValueChanged.value = true;
        },
        keyboardType: TextInputType.text,
        validator: (value) {
          return null;
        });
  }

  Widget _flightNumberWidget() {
    return _labelAndTextFieldWidget(
        'Flight Number', 'Flight Number', 'Enter Flight Number (Optional)',
        txtEditingController: controller.flightNumberController,
        onChanged: (val) {
          controller.isValueChanged.value = true;
        },
        keyboardType: TextInputType.text,
        validator: (value) {
          return null;
        });
  }

  Widget _refNumberWidget() {
    return _labelAndTextFieldWidget('Reference Number', 'Reference Number',
        'Enter Reference Number (Optional)',
        txtEditingController: controller.refNumberController,
        onChanged: (val) {
          controller.isValueChanged.value = true;
        },
        keyboardType: TextInputType.text,
        validator: (value) {
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
    return RemarksTextFieldTransparent(
        hintText: "Enter your remarks",
        keyboardType: TextInputType.multiline,
        textController: controller.remarksController,
        enable: true,
        autocorrect: false,
        textInputAction: TextInputAction.newline,
        onChanged: (val) {
          controller.isValueChanged.value = true;
        },
        autofocus: false);
  }

  Widget _labelCustomPricing() {
    return InkWell(
      onTap: () => {
        if (controller.showCustomPricing.value)
          controller.showCustomPricing.value = false
        else
          controller.showCustomPricing.value = true
      },
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => {
                if (controller.showCustomPricing.value)
                  controller.showCustomPricing.value = false
                else
                  controller.showCustomPricing.value = true
              },
              child: Text(
                'Custom Pricing',
                style: AppFontStyle.subHeading(
                  size: AppFontSize.medium.value,
                  color: AppColors.kPrimaryColor.value,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
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
      ),
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
                        child: _priceWidget()),
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
                        child: _extraChargesWidget()),
                  )),
                ],
              )
            ],
          )
        : const SizedBox.shrink());
  }

  Widget _labelAdditionalElements() {
    return InkWell(
      onTap: () => {
        if (controller.showAdditionalElements.value)
          controller.showAdditionalElements.value = false
        else
          controller.showAdditionalElements.value = true
      },
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => {
                if (controller.showAdditionalElements.value)
                  controller.showAdditionalElements.value = false
                else
                  controller.showAdditionalElements.value = true
              },
              child: Text(
                'Additional Elements',
                style: AppFontStyle.subHeading(
                  size: AppFontSize.medium.value,
                  color: AppColors.kPrimaryColor.value,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Obx(
            () => InkWell(
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
            ),
          ),
        ],
      ),
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
      firstDate: controller.dateTime.subtract(const Duration(days: 0)),
      lastDate: controller.dateTime.add(const Duration(days: 62)),
    );
    if (selected != null && selected != controller.selectedDate) {
      controller.isValueChanged.value = true;
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
      controller.isValueChanged.value = true;
      controller.selectedTime = selected;
    }
    return controller.selectedTime;
  }
}
