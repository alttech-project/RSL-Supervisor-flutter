import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/trip_history/data/trip_history_response.dart';
import 'package:rsl_supervisor/trip_history/service/trip_history_services.dart';

import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';

class TripHistoryController extends GetxController {
  SupervisorInfo supervisorInfo = SupervisorInfo();
  RxList<TripDetails> tripList = <TripDetails>[].obs;
  RxBool showLoader = false.obs;
  Rx<DateTime> fromDate = DateTime.now().subtract(const Duration(days: 1)).obs;
  Rx<DateTime> toDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    callTripHistoryApi();
  }

  void goBack() {
    Get.back();
  }

  void callTripHistoryApi() async {
    showLoader.value = true;
    DateTime today = DateTime.now();
    tripHistoryApi(
      TripHistoryRequest(
        kioskId: supervisorInfo.kioskId,
        driverName: "",
        tripId: "",
        from: DateFormat('yyyy-MM-d HH:mm')
            .format(today.subtract(const Duration(days: 7))),
        to: DateFormat('yyyy-MM-d HH:mm').format(today),
      ),
    ).then(
      (response) {
        showLoader.value = false;
        if ((response.status ?? 0) == 1) {
          tripList.value = response.details ?? [];
        } else {
          tripList.value = [];
          showSnackBar(
            title: 'Alert',
            msg: response.message ?? "Something went wrong...",
          );
        }
        tripList.refresh();
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        tripList.value = [];
        tripList.refresh();
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }

  String displayTimeFormatter(String pickupTime) {
    String convertedTime = "";
    try {
      DateTime dateTime = DateTime.parse(pickupTime);
      convertedTime = DateFormat('MMM d, y h:mm a').format(dateTime);
    } catch (e) {
      convertedTime = pickupTime;
    }

    return convertedTime;
  }
}
