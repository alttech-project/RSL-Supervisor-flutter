import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:rsl_supervisor/login/data/assign_supervisor_api_data.dart';
import 'package:rsl_supervisor/login/data/verify_otp_api_data.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';

import '../../shared/styles/app_color.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/verify_user_api_data.dart';
import '../service/login_services.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final OtpFieldController otpController = OtpFieldController();
  final GetStorageController _storageController =
      Get.find<GetStorageController>();

  RxBool apiLoading = false.obs;
  RxString otp = "".obs;
  Rx<LoginViews> currentView = LoginViews.emailPage.obs;
  List<KioskList> kioskList = <KioskList>[];
  var supervisorId = 0;
  var cid = 0;
  var kioskAddress = "";
  var kioskName = "";
  var kioskId = 0;
  var phoneNumber = "";
  var deviceToken = "";

  @override
  void onClose() {
    emailController.dispose();
    emailController.clear();
    otpController.clear();
    currentView.value = LoginViews.emailPage;
    kioskList = [];
    otp.value = "";
    supervisorId = 0;
    cid = 0;
    kioskAddress = "";
    kioskName = "";
    kioskId = 0;
    phoneNumber = "";
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    currentView.value = LoginViews.emailPage;
    getDeviceToken();
  }

  getDeviceToken() async {
    deviceToken = await _storageController.getDeviceToken();
  }

  onBackPressed() {
    if (apiLoading.value) return;

    if (currentView.value == LoginViews.otpPage) {
      currentView.value = LoginViews.emailPage;
    } else {
      SystemNavigator.pop();
    }
  }

  checkValidationAndCallApi() {
    String text = emailController.text.trim();
    if (GetUtils.isEmail(text) || GetUtils.isPhoneNumber(text)) {
      apiLoading.value = true;
      verifyUserNameApi(
        VerifyUserNameRequestData(
          companyDomain: 'regina',
          companyMainDomain: 'limor.us',
          cid: '',
          username: text,
          deviceToken: deviceToken,
        ),
      ).then(
        (response) {
          apiLoading.value = false;
          if (response.status == 1) {
            currentView.value = LoginViews.otpPage;
          } else {
            Get.snackbar('Alert', '${response.message}',
                backgroundColor: AppColors.kGetSnackBarColor.value);
          }
        },
      ).catchError(
        (onError) {
          apiLoading.value = false;
          Get.snackbar('Error!', onError.toString(),
              backgroundColor: AppColors.kGetSnackBarColor.value);
        },
      );
    } else {
      Get.snackbar('Alert', 'Enter valid Email/Phone!',
          backgroundColor: AppColors.kGetSnackBarColor.value);
    }
  }

  calVerfyOtpApi() {
    String username = emailController.text.trim();
    apiLoading.value = true;
    verifyOtpApi(
      VerifyOtpRequest(
        username: username,
        otp: otp.value,
        latitude: 11.031777,
        longitude: 77.013895,
        deviceToken: deviceToken,
      ),
    ).then(
      (response) {
        apiLoading.value = false;
        if (response.status == 1) {
          kioskList = response.detail?.kioskList ?? [];
          supervisorId = response.detail?.supervisorId ?? 0;
          cid = response.detail?.companyId ?? 0;
          kioskList = response.detail?.kioskList ?? [];
          kioskId = kioskList.isNotEmpty ? (kioskList[0].kioskId ?? 0) : 0;
          kioskAddress =
              kioskList.isNotEmpty ? (kioskList[0].address ?? "") : "";
          kioskName =
              kioskList.isNotEmpty ? (kioskList[0].kioskName ?? "") : "";
          phoneNumber = kioskList.isNotEmpty ? (kioskList[0].phone ?? "") : "";

          calAssignSupervisorApi();
        } else {
          Get.snackbar('Alert', '${response.message}',
              backgroundColor: AppColors.kGetSnackBarColor.value);
        }
      },
    ).catchError(
      (onError) {
        apiLoading.value = false;
        Get.snackbar('Error!', onError.toString(),
            backgroundColor: AppColors.kGetSnackBarColor.value);
      },
    );
  }

  calAssignSupervisorApi() {
    apiLoading.value = true;
    assignSupervisorApi(
      AssignSupervisorRequest(
        kioskId: kioskId,
        supervisorId: supervisorId,
        cid: cid,
        latitude: 11.031777,
        longitude: 77.013895,
        accuracy: 3.6324515342712402,
        deviceToken: deviceToken,
        photoUrl:
            "https://firebasestorage.googleapis.com/v0/b/rsl-passenger-b0629.appspot.com/o/Supervisor%2FPhotosVerification%2FPhotos_07-08-2023%2Fphoto_-2001340201?alt=media&token=94c2317c-80ce-4534-9a18-4000245313be",
      ),
    ).then(
      (response) {
        apiLoading.value = false;
        if (response.status == 1) {
          _storageController.saveSupervisorInfo(
            supervisorId: "$supervisorId",
            companyId: "$cid",
            kioskId: "$kioskId",
            kioskAddress: kioskAddress,
            phoneNumber: phoneNumber,
            kioskName: kioskName,
          );
          _storageController.saveNodeUrl(
              url: response.supervisorMonitorLogUrl ?? "");
          Get.offNamed(AppRoutes.dashboardPage);
        } else {
          Get.snackbar('Alert', '${response.message}',
              backgroundColor: AppColors.kGetSnackBarColor.value);
        }
      },
    ).catchError(
      (onError) {
        apiLoading.value = false;
        Get.snackbar('Error!', onError.toString(),
            backgroundColor: AppColors.kGetSnackBarColor.value);
      },
    );
  }
}

enum LoginViews { emailPage, otpPage }
