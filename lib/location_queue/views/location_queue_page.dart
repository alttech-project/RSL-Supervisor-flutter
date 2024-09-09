import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rsl_supervisor/location_queue/controllers/location_queue_controller.dart';
import 'package:rsl_supervisor/location_queue/widgets/driver_list_widget.dart';
import 'package:rsl_supervisor/location_queue/widgets/location_queue_app_bar.dart';
import 'package:rsl_supervisor/widgets/custom_app_container.dart';

import '../../shared/styles/app_color.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../widgets/app_loader.dart';
import '../widgets/location_queue_search_bar.dart';

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
                    const LocationQueueAppBar(),
                    const LocationQueueSearchBar(),
                    Flexible(
                      child: Obx(() => controller.showDriverListLoader.value
                          ? const Center(
                              child: AppLoader(),
                            )
                          : controller.filteredDriverList.isNotEmpty
                              ? ReorderableListView(
                                  scrollController: controller.scrollController,
                                  shrinkWrap: true,
                                  padding:
                                      EdgeInsets.only(top: 5.h, bottom: 10.h),
                                  onReorder: ((oldIndex, newIndex) {
                                    if (!controller.shiftStatus) {
                                      showSnackBar(
                                        title: 'Alert',
                                        msg:
                                            "You are not shift in.Please make shift in and try again!",
                                      );
                                    } else {
                                      List<int> driverArray = controller
                                          .filteredDriverList
                                          .map((element) =>
                                              (element.driverId ?? 0))
                                          .toList();
                                      if (newIndex > oldIndex) {
                                        newIndex -= 1;
                                      }
                                      final int item =
                                          driverArray.removeAt(oldIndex);
                                      driverArray.insert(newIndex, item);
                                      controller.callUpdateDriverQueueApi(
                                          driverArray: driverArray);
                                    }
                                  }),
                                  children: <Widget>[
                                    for (int index = 0;
                                        index <
                                            controller
                                                .filteredDriverList.length;
                                        index++)
                                      Builder(
                                        key: Key(controller
                                            .filteredDriverList[index].driverId
                                            .toString()),
                                        builder: (context) {
                                          final item = controller
                                              .filteredDriverList[index];
                                          final isHighlighted =
                                              controller.highlightedColor(
                                                  item); /*controller
                                                  .searchText.isNotEmpty &&
                                              (item.driverName ?? "")
                                                  .toLowerCase()
                                                  .contains(controller
                                                      .searchText
                                                      .toLowerCase()) ||
                                          controller.searchText.isNotEmpty &&
                                              (item.taxiNo ?? "")
                                                  .toLowerCase()
                                                  .contains(controller
                                                      .searchText
                                                      .toLowerCase());*/

                                          return AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            key: Key(item.driverId.toString()),
                                            /*color: isHighlighted
                                            ? AppColors.kPrimaryColor.value
                                                .withOpacity(0.5)
                                            : Colors.transparent,*/
                                            decoration: BoxDecoration(
                                              color: isHighlighted
                                                  ? AppColors
                                                      .kPrimaryTransparentColor
                                                      .value
                                                      .withOpacity(0.25)
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12.r),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 6.h,
                                                  top: 6.h,
                                                  left: 4.w,
                                                  right: 4.w),
                                              child: DriverListWidget(
                                                driverDetails: controller
                                                    .filteredDriverList[index],
                                                position: (index + 1),
                                                onTap: () {
                                                  if (!controller.shiftStatus) {
                                                    showSnackBar(
                                                      title: 'Alert',
                                                      msg:
                                                          "You are not shift in.Please make shift in and try again!",
                                                    );
                                                  } else {
                                                    /*if (controller
                                                            .fromDashboard !=
                                                        1) {
                                                      controller
                                                          .callDriverQueuePositionApi(
                                                              driverDetails:
                                                                  controller
                                                                          .filteredDriverList[
                                                                      index]);
                                                    }*/
                                                    controller
                                                        .callDriverQueuePositionApi(
                                                        driverDetails:
                                                        controller
                                                            .filteredDriverList[
                                                        index]);
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
                                                        driverDetails: controller
                                                                .filteredDriverList[
                                                            index]);
                                                  }
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                )
                              : SizedBox(
                                  height: 200.h,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No drivers available",
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )),
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
}
