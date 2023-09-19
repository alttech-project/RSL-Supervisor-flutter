import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/location_queue/controllers/location_queue_controller.dart';
import 'package:rsl_supervisor/location_queue/widgets/driver_list_widget.dart';
import 'package:rsl_supervisor/widgets/car_search_widget.dart';
import 'package:rsl_supervisor/widgets/custom_app_container.dart';
import 'package:rsl_supervisor/widgets/navigation_title.dart';

import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';

class LocationQueuePage extends GetView<LocationQueueController> {
  const LocationQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CommonAppContainer(
        showLoader: controller.showLoader.value,
        child: SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              controller.goBack();
              return false;
            },
            child: Scaffold(
              extendBodyBehindAppBar: false,
              backgroundColor: Colors.black,
              body: Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                  bottom: 12.h,
                ),
                child: Column(
                  children: [
                    NavigationBarWithIcon(
                      onTap: () => controller.goBack(),
                    ),
                    AddCarBtnWidget(
                      onTap: () {
                        if (!controller.shiftStatus) {
                          showSnackBar(
                            title: 'Alert',
                            msg:
                                "You are not shift in.Please make shift in and try again!",
                          );
                        } else {
                          _showDriverSearchWidget();
                        }
                      },
                    ),
                    Flexible(
                      child: ReorderableListView.builder(
                        itemCount: controller.driverList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.black,
                            key: Key('$index'),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: DriverListWidget(
                                driverDetails: controller.driverList[index],
                                position: (index + 1),
                                onTap: () {
                                  if (!controller.shiftStatus) {
                                    showSnackBar(
                                      title: 'Alert',
                                      msg:
                                          "You are not shift in.Please make shift in and try again!",
                                    );
                                  } else {
                                    controller.callDriverQueuePositionApi(
                                        driverDetails:
                                            controller.driverList[index]);
                                  }
                                },
                                removeDriver: () {
                                  if (!controller.shiftStatus) {
                                    showSnackBar(
                                      title: 'Alert',
                                      msg:
                                          "You are not shift in.Please make shift in and try again!",
                                    );
                                  } else {
                                    controller.showRemoveDriverAlert(
                                        driverDetails:
                                            controller.driverList[index]);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        onReorder: ((oldIndex, newIndex) {
                          if (!controller.shiftStatus) {
                            showSnackBar(
                              title: 'Alert',
                              msg:
                                  "You are not shift in.Please make shift in and try again!",
                            );
                          } else {
                            List<int> driverArray = controller.driverList
                                .map((element) => (element.driverId ?? 0))
                                .toList();
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final int item = driverArray.removeAt(oldIndex);
                            driverArray.insert(newIndex, item);
                            controller.callUpdateDriverQueueApi(
                                driverArray: driverArray);
                          }
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDriverSearchWidget() {
    controller.driverSearchText.value = "";
    controller.callSearchDriverApi();

    Get.bottomSheet(
      Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
          ),
          margin: EdgeInsets.only(top: 70.h),
          child: CarSearchView(
            onChanged: (text) {
              controller.driverSearchText.value = text;
              controller.callSearchDriverApi();
            },
            showLoader: controller.showDrverSearchLoader.value,
            listData: controller.driverSearchList
                .map((element) =>
                    ("${element.taxiNo ?? ""} - ${element.driverName ?? ""}"))
                .toList(),
            onSelect: (index) {
              Get.back();
              controller.showAddDriverAlert(
                  driverDetails: controller.driverSearchList[index]);
            },
            noDataText: "No cars found!",
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
