import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';
import '../../app.dart';
import '../utils/helpers/getx_storage.dart';
import '../views/services/splash_services.dart';

class AppStartController extends GetxController {
  Future<Status> callGetCoreApi(storageController) async {
    await getCoreApi().then(
      (response) {
        print("hi status1 ${response.status}");
        if ((response.status ?? 0) == 1) {
          print("hi status2 ${response.status}");
          if (response.details != null) {
            var details = response.details;
            GetStorageController()
                .saveMonitorNodeUrl(url: details?.monitorNodeUrl ?? "");
            GetStorageController()
                .saveNodeUrl(url: details?.referralNodeUrl ?? "");
            GetStorageController().saveRiderReferralUrl(
                url: details?.supervisorRiderReferral ?? 0);
            GetStorageController()
                .saveVideoDate(date: details?.videoDate ?? "");
            GetStorageController().saveImageDate(date: details?.imgDate ?? "");
          }
          final userInfo =  storageController.getSupervisorInfo();
          int? status = 2;

          if ((userInfo.supervisorId ?? "").isEmpty) {
            status = 2;
          } else {
            status = 1;
          }
          printLogs("AppStartController status: $status");
          return Status(status: status);
        } else {
          showSnackBar(
            title: 'Alert',
            msg: response.message ?? "Something went wrong...",
          );
          return Status(status: 0);

        }
      },
    ).onError(
      (error, stackTrace) {
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
        return Status(status: 0);

      },
    );
  }

  Future<Status> checkLoginStatus(
      GetStorageController storageController) async {
    final userInfo = await storageController.getSupervisorInfo();
    await Future.delayed(const Duration(seconds: 4));
    int? status = 2;

    if ((userInfo.supervisorId ?? "").isEmpty) {
      status = 2;
    } else {
      status = 1;
    }
    printLogs("AppStartController status: $status");
    return Status(status: status);
  }
}
