import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsl_supervisor/bookings/controller/booking_list_controller.dart';
import 'package:rsl_supervisor/bookings/controller/bookings_controller.dart';
import 'package:rsl_supervisor/bookings/ongoing_bookings_tab.dart';
import 'package:rsl_supervisor/bookings/upcoming_bookings_tab.dart';
import 'package:rsl_supervisor/bookings/data/motor_details_data.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';
import 'package:rsl_supervisor/widgets/custom_app_container.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/safe_area_container.dart';
import '../widgets/navigation_title.dart';
import 'data/get_package_data.dart';

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
            extendBodyBehindAppBar: false,
            backgroundColor: Colors.black,
            body: Obx(
              () => CommonAppContainer(
                showLoader: controller.apiLoading.value,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //Fill the code of padding
                      Padding(
                        padding:
                            EdgeInsets.only(left: 22.w, right: 22.w, top: 5.h),
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
                              _tabBarTextWidget(text: "Upcoming Bookings"),
                              _tabBarTextWidget(text: "Ongoing Bookings"),
                            ]),
                            SizedBox(
                              height: 5.h,
                            ),
                            Obx(
                              () => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: _tabView(
                                  controller.selectedTabBar.value,
                                  context,
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  TabBar _tabBarWidget({required List<Widget> tabs}) {
    final bookingListController = Get.find<BookingsListController>();
    return TabBar(
      isScrollable: true,
      onTap: (value) {
        controller.changeTabIndex(value);
        if (value == 0) {
          bookingListController.stopTripListTimer();
          bookingListController.stopTripListOngoingTimer();
        } else if (value == 1) {
          bookingListController.startTripListTimer();
          bookingListController.stopTripListOngoingTimer();
          bookingListController.callTripListOngoingApi(type: value);
        } else {
          bookingListController.startTripListOngoingTimer();
          bookingListController.stopTripListTimer();
          bookingListController.callTripListOngoingApi(type: value);
        }
      },
      controller: controller.tabController,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: AppColors.kPrimaryColor.value,
      labelColor: AppColors.kPrimaryColor.value,
      unselectedLabelColor: AppColors.kBackGroundColor.value,
      tabs: tabs,
    );
  }

  Widget _tabView(int value, context) {
    switch (value) {
      case 0:
        return newBookingsTab(context);
      case 1:
        return const UpcomingBookingsTab();
      case 2:
        return const OnGoingBookingsTab();
    }
    return const SizedBox.shrink();
  }

  _tabBarTextWidget({String? text}) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Text("$text",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                    textStyle: TextStyle(
                        fontSize: AppFontSize.medium.value,
                        fontWeight: AppFontWeight.semibold.value))),
          ],
        ),
      );

  Widget newBookingsTab(context) {
    return Column(
      children: [
        _personalInfo(context),
        SizedBox(height: 10.h),
        _locationInfo(context),
        SizedBox(height: 10.h),
        _carModelInfo(),
        SizedBox(height: 10.h),
        _bookingTypeInfo(),
        SizedBox(height: 10.h),
        controller.selectedBookingType.value.id == 1 &&
                controller.zoneFareApplied.value == 1
            ? Column(
                children: [
                  _tripTypeRadioWidget(),
                  SizedBox(height: 10.h),
                ],
              )
            : const SizedBox.shrink(),
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
              text: 'Submit',
              onTap: () => controller.checkNewBookingValidation()),
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

  Widget _tripTypeRadioWidget() {
    return Obx(
      () => Card(
        elevation: 8,
        margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12.r,
          ),
        ),
        color: AppColors.kPrimaryTransparentColor.value,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Trip Type',
                style: AppFontStyle.subHeading(
                  size: AppFontSize.medium.value,
                  color: AppColors.kPrimaryColor.value,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    activeColor: Colors.white /*AppColors.kPrimaryColor.value*/,
                    value: 1,
                    groupValue: controller.selectedTripRadioValue.value,
                    onChanged: (value) {
                      controller.tripTypeSelectedRadio(value);
                    },
                    fillColor: MaterialStateColor.resolveWith((states) =>
                        Colors.white /*AppColors.kPrimaryColor.value*/),
                  ),
                  Text(
                    'Normal',
                    style: AppFontStyle.subHeading(
                      size: AppFontSize.small.value,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Radio(
                    activeColor: Colors.white,
                    value: 2,
                    groupValue: controller.selectedTripRadioValue.value,
                    onChanged: (int? value) {
                      controller.tripTypeSelectedRadio(value);
                    },
                    fillColor: MaterialStateColor.resolveWith((states) =>
                        Colors.white /*AppColors.kPrimaryColor.value*/),
                  ),
                  Text(
                    'Round Trip',
                    style: AppFontStyle.subHeading(
                      size: AppFontSize.small.value,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              controller.selectedTripRadioValue.value == 2
                  ? _roundtripTypeRadioWidget()
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundtripTypeRadioWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Round Trip Fare', // Add your label here
            style: AppFontStyle.subHeading(
              size: AppFontSize.medium.value,
              color: AppColors.kPrimaryColor.value,
            ),
          ),
          SizedBox(height: 10.h),
          // Add some space between label and radio buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Radio(
                value: 0,
                groupValue: controller.roundTripselectedTripRadioValue.value,
                onChanged: (value) {
                  controller.roundedSelectedRadio(value);
                },
                fillColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
              ),
              Text(
                'Single',
                style: AppFontStyle.subHeading(
                  size: AppFontSize.small.value,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Radio(
                value: 1,
                groupValue: controller.roundTripselectedTripRadioValue.value,
                onChanged: (value) {
                  controller.roundedSelectedRadio(value!);
                },
                fillColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
              ),
              Text(
                'Double',
                style: AppFontStyle.subHeading(
                  size: AppFontSize.small.value,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
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
        textInputAction: TextInputAction.next, validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter guest name';
      }
      return null;
    });
  }

  Widget _phoneNumberWidget() {
    return CountryCodeTextField(
      controller: controller.phoneController,
      hint: 'Guest Phone Number',
      inputLblTxt: 'Guest Phone Number',
      inputLblStyle: AppFontStyle.subHeading(
          color: AppColors.kPrimaryColor.value, size: AppFontSize.medium.value),
      textInputAction: TextInputAction.next,
      onCountryChanged: (country) {
        controller.countryCode.value = country.dialCode;
      },
    );
  }

  Widget _emailIdWidget() {
    return _labelAndTextFieldWidget(
      'Guest Email',
      'Guest Email',
      'Enter Guest Email',
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

  Widget _labelPrice() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
        child: Text(
          'Customer Price',
          style: AppFontStyle.subHeading(
            size: AppFontSize.small.value,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _labelExtraCharges() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
        child: Text(
          'Extra Charges',
          style: AppFontStyle.subHeading(
            size: AppFontSize.small.value,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _priceWidget() {
    return BoxTextFieldTransparent(
        hintText: "0",
        keyboardType: TextInputType.datetime,
        textController: controller.priceController,
        enable: true,
        autocorrect: false,
        textInputAction: TextInputAction.next,
        onChanged: (value) => controller.calculateShares(value),
        onSubmitted: (value) => {controller.originalPrice = value},
        autofocus: false,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
        ],
    );
  }

  Widget _extraChargesWidget() {
    final FocusNode extraChargesFocusNode = FocusNode();
    extraChargesFocusNode.addListener(() {
      if (extraChargesFocusNode.hasFocus) {
        controller.originalPrice = controller.priceController.text.trim();
      }
    });
    return BoxTextFieldTransparent(
        hintText: "0",
        keyboardType: TextInputType.datetime,
        textController: controller.extraChargesController,
        enable: true,
        autocorrect: false,
        focusNode: extraChargesFocusNode,
        textInputAction: TextInputAction.done,
        onChanged: (value) => controller.handleExtraCharge(value),
        onSubmitted: (value) => controller.setExtraChargeForMinus(),
        autofocus: false,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
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
        keyboardType: TextInputType.text, validator: (value) {
      return null;
    });
  }

  Widget _refNumberWidget() {
    return _labelAndTextFieldWidget('Reference Number', 'Reference Number',
        'Enter Reference Number (Optional)',
        txtEditingController: controller.refNumberController,
        keyboardType: TextInputType.text, validator: (value) {
      return null;
    });
  }

  Widget _roomNumberWidget() {
    return _labelAndTextFieldWidget(
        'Room Number', 'Room Number', 'Enter Room Number (Optional)',
        txtEditingController: controller.roomNumberController,
        keyboardType: TextInputType.text, validator: (value) {
      return null;
    });
  }

  Widget _customerRateWidget() {
    return _labelAndTextFieldWidget(
        'Customer Rate', 'Customer Rate', 'Enter Customer Rate (Optional)',
        txtEditingController: controller.customRateController,
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
    return RemarksTextFieldTransparent(
        hintText: "Enter your remarks (Optional)",
        keyboardType: TextInputType.multiline,
        textController: controller.remarksController,
        enable: true,
        autocorrect: false,
        textInputAction: TextInputAction.newline,
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
                    child: Column(
                      children: [
                        _labelPrice(),
                        Card(
                          elevation: 8,
                          margin: const EdgeInsets.only(
                              bottom: 0, left: 0, right: 0),
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
                            child: _priceWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _labelExtraCharges(),
                        Card(
                          elevation: 8,
                          margin: const EdgeInsets.only(
                              bottom: 0, left: 0, right: 0),
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
                            child: _extraChargesWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
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
              _customerRateWidget(),
              _roomNumberWidget(),
              SizedBox(height: 10.h),
              _remarksLabel(),
              SizedBox(height: 7.h),
              _remarksCardView(),
            ],
          )
        : const SizedBox.shrink());
  }

  Widget _bookingTypeInfo() {
    return Card(
      elevation: 0,
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
          _layoutBookingTypeInfo(),
        ]),
      ),
    );
  }

  Widget _layoutBookingTypeInfo() {
    return Expanded(
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            _labelBookingType(),
            const SizedBox(
              height: 8,
            ),
            _selectedBookingType(),
            const SizedBox(
              height: 0,
            ),
            _layoutPackageInfo()
          ],
        ),
      ),
    );
  }

  Widget _labelBookingType() {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        'Booking Category',
        style: AppFontStyle.subHeading(
          size: AppFontSize.medium.value,
          color: AppColors.kPrimaryColor.value,
        ),
      ),
    );
  }

  Widget _selectedBookingType() {
    return SizedBox(
      width: double.maxFinite,
      height: 57,
      child: Card(
        elevation: 0,
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
                child: _bookingTypeDropDown(
                  selectedOption: controller.selectedBookingType.value,
                  onTap: (value) {
                    controller.selectedBookingType.value = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _layoutPackageInfo() {
    return Obx(() => controller.selectedBookingType.value.id == 3
        ? Padding(
            padding: const EdgeInsets.only(
                top: 15,
                bottom: 0,
                left: 0,
                right: 0), // Adjust left and right padding
            child: Row(children: [
              _layoutPackageType(),
              const SizedBox(
                width: 20,
              ),
              _layoutPackage()
            ]),
          )
        : const SizedBox.shrink());
  }

  Widget _layoutPackageType() {
    return Expanded(
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            _labelPackageType(),
            const SizedBox(
              height: 8,
            ),
            _selectedPackageType()
          ],
        ),
      ),
    );
  }

  Widget _layoutPackage() {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            _labelPackage(),
            const SizedBox(
              height: 8,
            ),
            _selectedPackage()
          ],
        ),
      ),
    );
  }

  Widget _labelPackageType() {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Package Type',
          style: AppFontStyle.subHeading(
            size: AppFontSize.small.value,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _labelPackage() {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Package',
          style: AppFontStyle.subHeading(
            size: AppFontSize.small.value,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _selectedPackageType() {
    return SizedBox(
      width: double.maxFinite,
      height: 57,
      child: Card(
        elevation: 0,
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
                child: _packageTypeDropDown(
                  selectedOption: controller.selectedPackageType.value,
                  onTap: (value) {
                    controller.selectedPackageType.value = value;
                    controller.callGetCorporatePackageListApi(true);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedPackage() {
    return SizedBox(
      width: double.maxFinite,
      height: 57,
      child: Card(
        elevation: 0,
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
                child: _packageDropDown(
                  selectedOption: controller.packageData.value,
                  onTap: (value) {
                    controller.packageData.value = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookingTypeDropDown(
      {required TripType? selectedOption,
      required Function(TripType value) onTap}) {
    return SizedBox(
      child: DropdownButton<TripType>(
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
        items:
            bookingTypeList.map<DropdownMenuItem<TripType>>((TripType value) {
          return DropdownMenuItem<TripType>(
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

  Widget _packageTypeDropDown(
      {required TripType? selectedOption,
      required Function(TripType value) onTap}) {
    return SizedBox(
      child: DropdownButton<TripType>(
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
        items:
            packageTypeList.map<DropdownMenuItem<TripType>>((TripType value) {
          return DropdownMenuItem<TripType>(
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

  Widget _packageDropDown(
      {required CorporatePackageList? selectedOption,
      required Function(CorporatePackageList value) onTap}) {
    return SizedBox(
      child: DropdownButton<CorporatePackageList>(
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
        items: controller.packageList
            .map<DropdownMenuItem<CorporatePackageList>>(
                (CorporatePackageList value) {
          return DropdownMenuItem<CorporatePackageList>(
            onTap: () {
              onTap(value);
            },
            value: value,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: value.id == 001
                  ? Text(
                      value.typeLabel.toString(),
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                            fontSize: AppFontSize.verySmall.value,
                            fontWeight: AppFontWeight.normal.value,
                            color: Colors.white),
                      ),
                    )
                  : Text(
                      "${value.duration.toString()}${value.typeLabel.toString()}-${value.km.toString()}KM-${value.amount.toString()}${value.currency.toString()}",
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
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: controller.dateTime.add(const Duration(days: 62)),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              primaryColor: AppColors.kPrimaryColor.value,
              hintColor: AppColors.kPrimaryColor.value,
              primarySwatch: Colors.grey,
              colorScheme: ColorScheme.light(
                  primary: AppColors.kPrimaryColor.value,
                  secondary: AppColors.kPrimaryColor.value.withOpacity(0.5)),
              buttonBarTheme: const ButtonBarThemeData(
                buttonTextTheme: ButtonTextTheme.primary,
              ),
            ),
            child: child!,
          );
        });

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
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              primaryColor: AppColors.kPrimaryColor.value,
              hintColor: AppColors.kPrimaryColor.value,
              primarySwatch: Colors.grey,
              colorScheme: ColorScheme.light(
                  primary: AppColors.kPrimaryColor.value,
                  secondary: AppColors.kPrimaryColor.value.withOpacity(0.5)),
              buttonBarTheme: const ButtonBarThemeData(
                buttonTextTheme: ButtonTextTheme.primary,
              ),
            ),
            child: child!,
          );
        });
    if (selected != null && selected != controller.selectedTime) {
      controller.selectedTime = selected;
    }
    return controller.selectedTime;
  }
}
