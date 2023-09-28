import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/feeds/data/feeds_api_data.dart';

import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../service/feeds_services.dart';

class FeedsController extends GetxController {
  RxBool apiLoading = false.obs;
  Rx<SupervisorInfo> supervisorInfo = SupervisorInfo().obs;
  RxList<FeedsList> feedsList = <FeedsList>[].obs;
  RxString noDataMsg = "No data found".obs;
  RxInt currentPage = 1.obs;
  RxInt limit = 10.obs;
  RxInt totalCount = 10.obs;
  RxBool pageNationLoader = false.obs;
  final ScrollController scrollController = ScrollController();



  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
    _scrollListenerFeedsList();
  }


  void _scrollListenerFeedsList() {

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadFeedsNextPage();
      }
    });
  }

  void loadFeedsNextPage() {
    if (currentPage.value * limit.value < totalCount.value) {
      currentPage.value++;
      _callFeedsListApi(pageNation: true);
    } else {
      pageNationLoader.value = false;

    }
  }






  _getUserInfo() async {
    supervisorInfo.value = await GetStorageController().getSupervisorInfo();
    _callFeedsListApi();
  }

  void _callFeedsListApi({bool pageNation = false}) async {
    if (pageNation == false) {
      apiLoading.value = true;
      pageNationLoader.value = false;
      currentPage.value = 1;
    } else {
    pageNationLoader.value = true;
    apiLoading.value = false;
       }
       feedsApi(FeedsApiRequest(
            id: supervisorInfo.value.supervisorId, pageLimit: limit.value, pageNumber: currentPage.value))
        .then((response) {
      if (pageNation == false) {
        apiLoading.value = false;
        if ((response.status ?? 0) == 1) {
          feedsList.value = response.feedsList ?? [];
          totalCount.value =  feedsList.length;
          feedsList.refresh();
          noDataMsg.value = response.message ?? "";
        } else {
          noDataMsg.value = response.message ?? "No Data found";
          feedsList.value = [];
          feedsList.refresh();
          pageNationLoader.value = false;

        }
      } else {
        feedsList?.addAll(response.feedsList ?? []);
        feedsList.refresh();
        apiLoading.value = false;

      }
    }).onError((error, stackTrace) {
      apiLoading.value = false;
      pageNationLoader.value = false;

      printLogs("Feeds api error: ${error.toString()}");
      feedsList.value = [];
      feedsList.refresh();
    });
  }
}
