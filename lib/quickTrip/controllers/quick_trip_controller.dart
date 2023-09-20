import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import 'package:rsl_supervisor/scanner/controllers/scanner_controller.dart';

import '../../shared/styles/app_color.dart';
import '../../utils/helpers/alert_helpers.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/quick_trip_api_data.dart';
import '../service/quick_trip_services.dart';

class QuickTripController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController tripIdController = TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController paymentIdController = TextEditingController();

  var countryCode = '971'.obs;
  var apiLoading = false.obs;
  SupervisorInfo? supervisorInfo;

  double dropLatitude = 0.0, dropLongitude = 0.0;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  @override
  void onReady() {
    print('hiTamil QTC onReady');
    super.onReady();
  }

  @override
  void onClose() {
    print('hiTamil QTC onClose');
    // tripIdController.dispose();
    // dropLocationController.dispose();
    // fareController.dispose();
    // nameController.dispose();
    // phoneController.dispose();
    // emailController.dispose();
    // paymentIdController.dispose();
    super.onClose();
  }

  void clearTripId() {
    tripIdController.clear();
  }

  void clearDropLocation() {
    dropLocationController.clear();
  }

  void checkValidation() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (formKey.currentState!.validate()) {
      final tripID = tripIdController.text.trim();
      final dropLocation = dropLocationController.text.trim();
      final fare = fareController.text.trim();
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();
      final email = emailController.text.trim();
      final paymentId = paymentIdController.text.trim();

      //GetUtils.isEmail(text) || GetUtils.isPhoneNumber(text)
      if (tripID.isEmpty) {
        _showSnackBar('Validation!', 'Enter a valid Trip ID!');
      } else if (dropLocation.isEmpty) {
        _showSnackBar('Validation!', 'Select / Enter a valid drop location!');
      } else if (phone.isNotEmpty && !GetUtils.isPhoneNumber(phone)) {
        _showSnackBar('Validation!', 'Enter a valid phone number!');
      } else if (email.isNotEmpty && !GetUtils.isEmail(email)) {
        _showSnackBar('Validation!', 'Enter a valid Email!');
      } else {
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

  void navigateToScannerAndFetch() async {
    final result = await Get.toNamed(AppRoutes.qrScannerPage);
    if (result is QrResult) {
      tripIdController.text = result.data?.code ?? '';
    }
  }

  _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    // deviceToken = await GetStorageController().getDeviceToken();
  }

  void _showSnackBar(String title, String message) {
    Get.snackbar(title, message,
        backgroundColor: AppColors.kGetSnackBarColor.value);
  }

  void _handleDispatchQuickTripResponse(
      DispatchQuickTripResponseData response) {
    switch (response.status) {
      case 1:
        showAppDialog(
          title: 'Success',
          message: '${response.message}',
          content: QrImageView(
            data: '${response.trackUrl}',
            version: QrVersions.auto,
            size: 200.0,
          ),
          confirm: defaultAlertConfirm(
            onPressed: () {
              Get.back();
            },
          ),
        );
        break;
      default:
        _showSnackBar('Error', response.message ?? 'Server Connection Error!');
    }
  }
}
