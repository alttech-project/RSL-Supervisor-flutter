import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers/alert_helpers.dart';
import '../../utils/helpers/basic_utils.dart';
import '../data/rider_referral_api_data.dart';
import '../service/rider_referral_service.dart';

class RiderReferralController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  var countryCode = '971'.obs;
  RxBool showLoader = false.obs;
  final dashBoardController = Get.find<DashBoardController>();
  Rx<Details> promoDetails = Details().obs;
  RxList<ReferralHistory> referralHistory = <ReferralHistory>[].obs;

  void callRiderReferralApi(int? supervisorId) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    showLoader.value = true;
    riderReferralApi(
      RiderReferralRequest(supervisorId: supervisorId),
    ).then(
      (response) {
        showLoader.value = false;
        if (response.status == 1) {
          promoDetails.value = response.details ?? Details();
        } else {
          showSnackBar(
            title: 'Error',
            msg: response.message ?? "Something went wrong",
          );
          showLoader.value = false;

        }
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        showDefaultDialog(
          context: Get.context!,
          title: "Error",
          message: error.toString(),
        );
      },
    );
  }

  void callRideReferralMsgAPi(
      int? supervisorId, String? countryCode, String? passengerPhone) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    showLoader.value = true;
    riderRefferalMsgApi(
      RiderReferralMessageRequestData(
          supervisorId: supervisorId,
          countryCode: countryCode,
          passengerPhone: passengerPhone),
    ).then(
      (response) {
        showLoader.value = false;
        if (response.status == 1) {
          print("response$response");
        } else {
          showSnackBar(
            title: 'Error',
            msg: response.message ?? "Something went wrong",
          );
          showLoader.value = false;

        }
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        showDefaultDialog(
          context: Get.context!,
          title: "Error",
          message: error.toString(),
        );
      },
    );
  }

  void callRiderReferralHistoryApi(int? supervisorId) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    showLoader.value = true;
    riderRefferalHistoryApi(
      RiderReferralHistoryRequestData(
        supervisorId: supervisorId,
      ),
    ).then(
      (response) {
        showLoader.value = false;
        if (response.status == 1) {
          referralHistory.value =
              response.referralHistoryDetails?.referralHistory ?? [];
          Get.toNamed(AppRoutes.riderReferralHistoryPage);
        } else {
          showSnackBar(
            title: 'Error',
            msg: response.message ?? "Something went wrong",
          );
        }
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        showDefaultDialog(
          context: Get.context!,
          title: "Error",
          message: error.toString(),
        );
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    callRiderReferralApi(int.parse(dashBoardController.supervisorInfo.value.supervisorId ?? ""));
  }

  void shareReferralCode() {
    final String referralCodeLink = promoDetails.value.referralCodeLink ?? "";
    final String description = promoDetails.value.description ?? "";
    Share.share('$description\n$referralCodeLink');
  }


}
