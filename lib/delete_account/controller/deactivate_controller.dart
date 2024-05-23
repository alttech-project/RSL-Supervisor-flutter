import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/deactivate_account_dart.dart';
import '../service/deactivate_service.dart';

class DeactivateAccountController extends GetxController {
  TextEditingController reasonController = TextEditingController();
  Rx<SupervisorInfo> supervisorInfo = SupervisorInfo().obs;
  RxBool apiLoading = false.obs;

  void _callDeactivateAccountApi() async {
    final superVisorInfo = await GetStorageController().getSupervisorInfo();
    apiLoading.value = true;
    accountDeactivateApi(
      DeactivateAccountRequestedData(
          reason: reasonController.text ?? "",
          supervisorId: superVisorInfo.supervisorId ?? ""),
    ).then(
      (response) {
        apiLoading.value = false;
        if (response.status == 1) {
          Get.snackbar('Message', response.message ?? "",
              backgroundColor: AppColors.kGetSnackBarColor.value);
          GetStorageController().removeSupervisorInfo();
          Get.offAllNamed(AppRoutes.loginPage);
        } else {
          Get.snackbar('Message', response.message ?? "",
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

  Future<dynamic> showDialog() {
    return Get.dialog(
        Dialog(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Are you sure want to deactivate this\naccount?",style: TextStyle(fontSize: 16.sp)),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _onTapWidget(
                          text: "NO",
                          onTap: () {
                            Get.back();
                          },
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        _onTapWidget(
                          text: "YES",
                          onTap: () {

                            _callDeactivateAccountApi();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
        useSafeArea: false);
  }

  InkWell _onTapWidget({void Function()? onTap, String? text}) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          child: Text(
            "$text",
            style: TextStyle(
                color: AppColors.kPrimaryColor.value,
                fontSize: AppFontSize.small.value),
          ),
        ));
  }
}
