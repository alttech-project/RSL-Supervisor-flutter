import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rsl_supervisor/feeds/data/feeds_api_data.dart';

import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../service/feeds_services.dart';

class FeedsController extends GetxController {
  RxBool apiLoading = false.obs;
  Rx<SupervisorInfo> supervisorInfo = SupervisorInfo().obs;
  RxList<FeedsList> feedsList = <FeedsList>[].obs;
  RxString noDataMsg = "No data found".obs;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  _getUserInfo() async {
    supervisorInfo.value = await GetStorageController().getSupervisorInfo();
    _callFeedsListApi();
  }

  void _callFeedsListApi() async {
    apiLoading.value = true;
    feedsApi(FeedsApiRequest(
            id: supervisorInfo.value.supervisorId, pageLimit: 1, pageNumber: 1))
        .then((response) {
      apiLoading.value = false;
      if ((response.status ?? 0) == 1) {
        feedsList.value = response.feedsList ?? [];
        feedsList.refresh();
        noDataMsg.value = response.message ?? "";
      } else {
        noDataMsg.value = response.message ?? "No Data found";
        feedsList.value = [];
        feedsList.refresh();
      }
    }).onError((error, stackTrace) {
      apiLoading.value = false;
      printLogs("Feeds api error: ${error.toString()}");
      feedsList.value = [];
      feedsList.refresh();
    });
  }
}
