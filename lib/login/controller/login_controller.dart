import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:rsl_supervisor/login/data/assign_supervisor_api_data.dart';
import 'package:rsl_supervisor/login/data/verify_otp_api_data.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';

import '../../shared/styles/app_color.dart';
import '../../utils/helpers/getx_storage.dart';
import '../../utils/helpers/location_manager.dart';
import '../data/verify_user_api_data.dart';
import '../service/login_services.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final OtpFieldController otpController = OtpFieldController();
  final LocationManager locationManager = LocationManager();
  RxBool apiLoading = false.obs;
  RxString otp = "".obs;
  Rx<LoginViews> currentView = LoginViews.emailPage.obs;
  List<KioskList> kioskList = <KioskList>[];
  var supervisorId = 0;
  var supervisorName = "";
  var supervisorUniqueId = "";
  var cid = 0;
  var kioskAddress = "";
  var kioskName = "";
  var kioskId = 0;
  var phoneNumber = "";
  var deviceToken = "";

  @override
  void onInit() {
    super.onInit();
    currentView.value = LoginViews.emailPage;
    getDeviceToken();
  }

  getDeviceToken() async {
    deviceToken = await GetStorageController().getDeviceToken();
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

  callResendOtpApi() {
    otpController.clear();
    otp.value = "";
    FocusManager.instance.primaryFocus?.unfocus();
    String text = emailController.text.trim();
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
          Get.snackbar('Success', '${response.message}',
              backgroundColor: AppColors.kGetSnackBarColor.value);
          otpController.setFocus(0);
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

  calVerfyOtpApi() async {
    String username = emailController.text.trim();
    apiLoading.value = true;

    LocationResult<Position> result =
        await locationManager.getCurrentLocation();

    if (result.data != null) {
      verifyOtpApi(
        VerifyOtpRequest(
          username: username,
          otp: otp.value,
          latitude: result.data!.latitude,
          longitude: result.data!.longitude,
          deviceToken: deviceToken,
        ),
      ).then(
        (response) {
          apiLoading.value = false;
          if (response.status == 1) {
            kioskList = response.detail?.kioskList ?? [];
            supervisorId = response.detail?.supervisorId ?? 0;
            supervisorName = response.detail?.name ?? "";
            supervisorUniqueId = response.detail?.uniqueId ?? "";
            cid = response.detail?.companyId ?? 0;
            kioskList = response.detail?.kioskList ?? [];
            kioskId = kioskList.isNotEmpty ? (kioskList[0].kioskId ?? 0) : 0;
            kioskAddress =
                kioskList.isNotEmpty ? (kioskList[0].address ?? "") : "";
            kioskName =
                kioskList.isNotEmpty ? (kioskList[0].kioskName ?? "") : "";
            phoneNumber =
                kioskList.isNotEmpty ? (kioskList[0].phone ?? "") : "";

            callAssignSupervisorApi();
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
      apiLoading.value = false;
      Get.defaultDialog(
          title: "ERROR!",
          middleText:
              result.error ?? "Error occured while fetching current location");
    }
  }

  callAssignSupervisorApi() async {
    apiLoading.value = true;
    LocationResult<Position> result =
        await locationManager.getCurrentLocation();

    if (result.data != null) {
      assignSupervisorApi(
        AssignSupervisorRequest(
          kioskId: kioskId,
          supervisorId: supervisorId,
          cid: cid,
          latitude: result.data!.latitude,
          longitude: result.data!.longitude,
          accuracy: result.data!.altitude,
          deviceToken: deviceToken,
          photoUrl:
              "https://firebasestorage.googleapis.com/v0/b/rsl-passenger-b0629.appspot.com/o/Supervisor%2FPhotosVerification%2FPhotos_07-08-2023%2Fphoto_-2001340201?alt=media&token=94c2317c-80ce-4534-9a18-4000245313be",
        ),
      ).then(
        (response) {
          apiLoading.value = false;
          if (response.status == 1) {
            var supervisorInfo = SupervisorInfo(
              supervisorId: "$supervisorId",
              supervisorName: supervisorName,
              supervisorUniqueId: supervisorUniqueId,
              cid: "$cid",
              kioskId: "$kioskId",
              kioskAddress: kioskAddress,
              kioskName: kioskName,
              phoneNumber: phoneNumber,
            );
            GetStorageController()
                .saveSupervisorInfo(supervisorInfo: supervisorInfo);
            GetStorageController()
                .saveNodeUrl(url: response.supervisorMonitorLogUrl ?? "");
            resetView();
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
    } else {
      apiLoading.value = false;
      Get.defaultDialog(
          title: "ERROR!",
          middleText:
              result.error ?? "Error occured while fetching current location");
    }
  }

  resetView() {
    emailController.clear();
    otpController.clear();
    currentView.value = LoginViews.emailPage;
    kioskList = [];
    otp.value = "";
    supervisorId = 0;
    supervisorName = "";
    supervisorUniqueId = "";
    cid = 0;
    kioskAddress = "";
    kioskName = "";
    kioskId = 0;
    phoneNumber = "";
  }
}

enum LoginViews { emailPage, otpPage }
