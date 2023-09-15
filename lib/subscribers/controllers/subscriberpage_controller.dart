import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../dashboard/controllers/dashboard_controller.dart';
import '../../utils/helpers/basic_utils.dart';
import '../data/subscriber_list_api_data.dart';
import '../services/subscriber_service.dart';

class SubscribersController extends GetxController {
  // ...
  RxString searchText = ''.obs;
  RxList<DriverList> filteredDriverList = <DriverList>[].obs;
  RxBool showLoader = false.obs;
  RxList<DriverList> subscriberList = <DriverList>[].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxString searchTxt = "".obs;
  final dashBoardController = Get.find<DashBoardController>();



  Future<void> refreshData() async {
    callTaxiListApi();
  }

  void setSearchText(String value) {
    searchText.value = value;
  }

  void callTaxiListApi() {
    showLoader.value = true;
    subscribeListApi(
      SubscriberListRequestData(
        kioskId: dashBoardController.supervisorInfo.value.kioskId,
        companyId: dashBoardController.supervisorInfo.value.cid,
      ),
    ).then((response) {
      showLoader.value = false;
      _handleSubscriberList(response);
    }).catchError((onError) {
      showLoader.value = false;
      showSnackBar(
        title: 'Error',
        msg: 'Server Connection Error!',
      );
    });
  }

  @override
  void onInit() {
    super.onInit();
    callTaxiListApi();
  }


  filterDriverList(String text) {
    if (text.isEmpty) {
      filteredDriverList.value = subscriberList;
      filteredDriverList.refresh();
      return;
    }

    filteredDriverList.value = subscriberList
        .where((searchName) => (searchName.driverName ?? "")
            .toLowerCase()
            .contains(text.toLowerCase()))
        .toList();
    filteredDriverList.refresh();
  }

  void _handleSubscriberList(SubscriberListResponseData response) {
    switch (response.status) {
      case 1:
        subscriberList.value = response.details?.driverList ?? [];
        filteredDriverList
          ..value = response.details?.driverList ?? []
          ..refresh();
        subscriberList.refresh();
        break;
      default:
        showSnackBar(
            msg: response.message ?? 'Server Connection Error!',
            title: 'Error');
    }
  }
}
