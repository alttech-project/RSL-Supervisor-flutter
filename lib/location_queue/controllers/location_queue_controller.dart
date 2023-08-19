import 'dart:async';

import 'package:get/get.dart';
import 'package:rsl_supervisor/location_queue/data/add_driver_response.dart';
import 'package:rsl_supervisor/location_queue/data/driver_list_response.dart';
import 'package:rsl_supervisor/location_queue/data/driver_queue_position_response.dart';
import 'package:rsl_supervisor/location_queue/service/location_queue_service.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';

import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';

class LocationQueueController extends GetxController {
  SupervisorInfo supervisorInfo = SupervisorInfo();
  RxList<DriverDetails> driverList = <DriverDetails>[].obs;
  Timer? _timer;
  RxBool showLoader = false.obs;
  RxBool isReorder = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    _callDriverListApi(isOninit: true);
    startTimer();
  }

  void goBack() {
    stopTimer();
    Get.back();
  }

  void startTimer() {
    stopTimer();
    const timerDuration = Duration(seconds: 5);

    _timer = Timer.periodic(
      timerDuration,
      (Timer timer) {
        _callDriverListApi();
      },
    );
  }

  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  void _callDriverListApi({bool? isOninit}) async {
    driverListApi(
      DriverListRequest(
        supervisorId: supervisorInfo.supervisorId,
        cid: supervisorInfo.cid,
        kioskId: supervisorInfo.kioskId,
      ),
    ).then(
      (response) {
        if ((response.status ?? 0) == 1) {
          driverList.value = response.driverList ?? [];
          driverList.refresh();
        } else if ((response.status ?? 0) == -4) {
          stopTimer();
          GetStorageController().removeSupervisorInfo();
          Get.offAllNamed(AppRoutes.loginPage);
        } else {
          if (isOninit ?? false) {
            showSnackBar(
              title: 'Alert',
              msg: response.message ?? "Something went wrong...",
            );
          }
        }
      },
    ).onError(
      (error, stackTrace) {
        if (isOninit ?? false) {
          showSnackBar(
            title: 'Error',
            msg: error.toString(),
          );
        }
      },
    );
  }

  void callUpdateDriverQueueApi({required List<int> driverArray}) async {
    showLoader.value = true;
    updateDriverQueueApi(
      UpdateDriverQueueRequest(
        driverArray: driverArray,
        cid: supervisorInfo.cid,
        kioskId: supervisorInfo.kioskId,
      ),
    ).then(
      (response) {
        showLoader.value = false;
        if ((response.status ?? 0) == 1) {
          driverList.value = response.driverList ?? [];
          driverList.refresh();
        } else {
          showSnackBar(
            title: 'Alert',
            msg: response.message ?? "Something went wrong...",
          );
        }
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }

  void callDriverQueuePositionApi(
      {required DriverDetails driverDetails}) async {
    showLoader.value = true;
    driverQueuePositionApi(
      DriverQueuePositionRequest(
        driverId: driverDetails.driverId,
        modelId: driverDetails.modelId,
        cid: supervisorInfo.cid,
        kioskId: supervisorInfo.kioskId,
      ),
    ).then(
      (response) {
        showLoader.value = false;
        if ((response.status ?? 0) == 1) {
          showSnackBar(
            title: 'Success',
            msg: response.message ?? "Something went wrong...",
          );
        } else {
          showSnackBar(
            title: 'Error',
            msg: response.message ?? "Something went wrong...",
          );
        }
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }

  void callAddDriverApi(
      {required DriverDetails driverDetails, required int type}) async {
    showLoader.value = true;
    addDriverApi(
      AddDriverRequest(
        driverId: driverDetails.driverId,
        modelId: driverDetails.modelId,
        cid: supervisorInfo.cid,
        kioskId: supervisorInfo.kioskId,
        requestType: "$type",
      ),
    ).then(
      (response) {
        showLoader.value = false;
        if ((response.status ?? 0) == 1) {
          showSnackBar(
            title: 'Success',
            msg: response.message ?? "Something went wrong...",
          );
          _callDriverListApi();
        } else {
          showSnackBar(
            title: 'Error',
            msg: response.message ?? "Something went wrong...",
          );
        }
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }
}
