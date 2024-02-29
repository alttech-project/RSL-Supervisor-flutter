import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import 'package:rsl_supervisor/scanner/controllers/scanner_controller.dart';

import '../../bookings/data/motor_details_data.dart';
import '../../network/app_config.dart';
import '../../place_search/data/get_place_details_response.dart';
import '../../shared/styles/app_color.dart';
import '../../utils/helpers/alert_helpers.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/quick_trip_api_data.dart';
import '../service/quick_trip_services.dart';

class QuickTripController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController tripIdController = TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController customPriceController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController paymentIdController = TextEditingController();
  final TextEditingController referenceNumberController =
      TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  RxString locationType = "".obs;
  RxInt pageType = 0.obs;
  RxInt enableEditFare = 0.obs;
  RxString fareText = ''.obs;

  var countryCode = '971'.obs;
  var apiLoading = false.obs;
  SupervisorInfo? supervisorInfo;
  String originalFare = "0";

  double dropLatitude = 0.0, dropLongitude = 0.0;

  Rx<Payments> selectedPayment = quickTripsPaymentList[0].obs;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    clearDatas();
/*    tripIdController.dispose();
    dropLocationController.dispose();
    fareController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    paymentIdController.dispose();*/
    super.onClose();
  }

  void clearTripId() {
    tripIdController.clear();
  }

  void clearDropLocation() {
    dropLocationController.clear();
  }

  void checkValidation() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    bool shiftStatus = await GetStorageController().getShiftStatus();
    if (!shiftStatus) {
      showSnackBar(
        title: 'Alert',
        msg: "You are not shift in.Please make shift in and try again!",
      );
    } else {
      if (locationType.value == LocationType.GENERAL.toString()) {
        if (formKey.currentState!.validate()) {
          final tripID = tripIdController.text.trim();
          final dropLocation = dropLocationController.text.trim();
          final fare = fareController.text.trim();
          final name = nameController.text.trim();
          final phone = phoneController.text.trim();
          final email = emailController.text.trim();
          final paymentId = paymentIdController.text.trim();
          final referenceNumber = referenceNumberController.text.trim();
          final remarks = remarksController.text.trim();

          if (tripID.isEmpty) {
            _showSnackBar('Validation!', 'Enter a valid Trip Id!');
          } else if (fare.isNotEmpty && double.parse(fare) <= 0) {
            _showSnackBar('Validation!', 'Enter a valid fare!');
          } else if (phone.isNotEmpty && !GetUtils.isPhoneNumber(phone)) {
            _showSnackBar('Validation!', 'Enter a valid phone number!');
          } else if (email.isNotEmpty && !GetUtils.isEmail(email)) {
            _showSnackBar('Validation!', 'Enter a valid email!');
          }
          /*else if (remarks.isEmpty) {
            _showSnackBar('Validation!', 'Enter a valid remarks!');
          } */
          else {
            if (supervisorInfo == null) {
              _showSnackBar('Error!', 'Invalid user login status!');
              return;
            }

            apiLoading.value = true;
            dispatchQuickTripApi(
              DispatchQuickTripRequestData(
                tripId: tripID,
                kioskId: supervisorInfo!.kioskId,
                companyId: supervisorInfo!.cid,
                supervisorName: supervisorInfo!.supervisorName,
                supervisorId: supervisorInfo!.supervisorId,
                supervisorUniqueId: supervisorInfo!.supervisorUniqueId,
                name: name,
                countryCode: countryCode.value,
                mobileNo: phone,
                email: email,
                fixedMeter: (fare.isEmpty) ? '2' : '1',
                kioskFare: fare,
                paymentId: paymentId,
                dropLatitude: dropLatitude,
                dropLongitude: dropLongitude,
                dropplace: dropLocation,
                referenceNumber: referenceNumber,
                remarks: remarks,
                paymentOption: int.parse(selectedPayment.value.paymentId),
              ),
            ).then((response) {
              apiLoading.value = false;
              _handleDispatchQuickTripResponse(response);
            }).catchError((onError) {
              apiLoading.value = false;
              _showSnackBar('Error', 'Server Connection Error!');
            });
          }
        }
      } else {
        if (formKey.currentState!.validate()) {
          final tripID = tripIdController.text.trim();
          final dropLocation = dropLocationController.text.trim();
          final fare = fareController.text.trim();
          final name = nameController.text.trim();
          final phone = phoneController.text.trim();
          final email = emailController.text.trim();
          final paymentId = paymentIdController.text.trim();
          final referenceNumber = referenceNumberController.text.trim();
          final remarks = remarksController.text.trim();
          final customPrice = customPriceController.text.trim();

          String customerPrice;
          if (customPrice.isEmpty) {
            customerPrice = "0";
          } else {
            customerPrice = customPrice;
          }

          if (tripID.isEmpty) {
            _showSnackBar('Validation!', 'Enter a valid Trip Id!');
          } else if (dropLocation.isEmpty) {
            _showSnackBar('Validation!', 'Enter a valid drop location!');
          } else if (fare.isEmpty || double.parse(fare) <= 0) {
            _showSnackBar('Validation!', 'Enter a valid fare!');
          } else if (phone.isNotEmpty && !GetUtils.isPhoneNumber(phone)) {
            _showSnackBar('Validation!', 'Enter a valid phone number!');
          } else if (email.isNotEmpty && !GetUtils.isEmail(email)) {
            _showSnackBar('Validation!', 'Enter a valid email!');
          }
          /*else if (remarks.isEmpty) {
            _showSnackBar('Validation!', 'Enter a valid remarks!');
          } */
          else {
            if (supervisorInfo == null) {
              _showSnackBar('Error!', 'Invalid user login status!');
              return;
            }

            apiLoading.value = true;
            dispatchQuickTripApi(
              DispatchQuickTripRequestData(
                tripId: tripID,
                kioskId: supervisorInfo!.kioskId,
                companyId: supervisorInfo!.cid,
                supervisorName: supervisorInfo!.supervisorName,
                supervisorId: supervisorInfo!.supervisorId,
                supervisorUniqueId: supervisorInfo!.supervisorUniqueId,
                name: name,
                countryCode: countryCode.value,
                mobileNo: phone,
                email: email,
                fixedMeter: (fare.isEmpty) ? '2' : '1',
                kioskFare: fare,
                paymentId: paymentId,
                dropLatitude: dropLatitude,
                dropLongitude: dropLongitude,
                dropplace: dropLocation,
                referenceNumber: referenceNumber,
                remarks: remarks,
                customPrice: double.parse(customerPrice),
                paymentOption: int.parse(selectedPayment.value.paymentId),
              ),
            ).then((response) {
              apiLoading.value = false;
              _handleDispatchQuickTripResponse(response);
            }).catchError((onError) {
              apiLoading.value = false;
              _showSnackBar('Error', 'Server Connection Error!');
            });
          }
        }
      }
    }
  }

  void navigateToScannerAndFetch() async {
    final result = await Get.toNamed(AppRoutes.qrScannerPage);
    if (result is QrResult) {
      // print("navigateToScannerAndFetch -> ${result.data?.code ?? ''}");
      tripIdController.text = result.data?.code ?? '';
    }
  }

  _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    locationType.value = await GetStorageController().getLocationType();
    enableEditFare.value = await GetStorageController().getEditFare();
    // deviceToken = await GetStorageController().getDeviceToken();
  }

  void _showSnackBar(String title, String message) {
    Get.snackbar(title, message,
        backgroundColor: AppColors.kGetSnackBarColor.value);
  }

  void setDiscountError(bool discount) {
    if (discount == true) {
      Future.delayed(const Duration(seconds: 1), () {
        customPriceController.clear();
        if (originalFare != "0") {
          fareController.text = originalFare.toString();
        }
      });
      showSnackBar(
        title: 'Error',
        msg: "Discount cannot be greater than the fare",
      );
    }
  }

  void updateFare(String discount) async {
    var discountValue = await GetStorageController().getDiscountValue();
    if (discountValue == 0) {
      String discountFare = discount.replaceAll('-', '');
      double discountValue =
          discountFare.isEmpty ? 0.0 : double.parse(discountFare);
      if (discount.isNotEmpty) {
        if (discountValue >= double.parse(originalFare)) {
          setDiscountError(true);
          return;
        } else {
          setDiscountError(false);
        }
      }
      if (originalFare != "0") {
        double adjustedPrice = double.parse(originalFare) - discountValue;
        fareController.text = adjustedPrice.toString();
      }
    } else {
      double customPriceValue = discount.isEmpty ? 0.0 : double.parse(discount);
      double adjustedPrice = double.parse(originalFare) + customPriceValue;
      fareController.text = adjustedPrice.toString();
    }
  }

  void _handleDispatchQuickTripResponse(
      DispatchQuickTripResponseData response) {
    switch (response.status) {
      case 1:
        clearDatas();
        showAppDialog(
          title: '${response.message}',
          message: '${response.message}',
          content: QrImageView(
            data: '${response.trackUrl}',
            version: QrVersions.auto,
            size: 200.0,
          ),
          confirm: defaultAlertConfirm(
            onPressed: () {
              navigateToDashboardPage();
            },
          ),
        );
        break;
      default:
        _showSnackBar('Error', response.message ?? 'Server Connection Error!');
    }
  }

  void navigateToDashboardPage() async {
    await Get.toNamed(
      AppRoutes.dashboardPage,
    );
  }

  void navigateToPlaceSearchPage() async {
    final result = await Get.toNamed(
      AppRoutes.placeSearchPage,
    );

    if (result is PlaceDetails) {
      dropLocationController.text = result.formattedAddress ?? '';
      dropLatitude = result.geometry?.location?.lat ?? 0.0;
      dropLongitude = result.geometry?.location?.lng ?? 0.0;
    }
  }

  void clearDatas() {
    clearTripId();
    clearDropLocation();
    selectedPayment.value = quickTripsPaymentList[0];
    dropLatitude = 0.0;
    dropLongitude = 0.0;
    fareController.text = "0";
    fareController.clear();
    originalFare = "0";
    customPriceController.clear();
    referenceNumberController.clear();
    remarksController.clear();
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    paymentIdController.clear();
  }
}
