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
                          : controller.filteredDriverList.isNotEmpty ||
                                  controller
                                      .filteredSecondaryDriverList.isNotEmpty
                              ? /*ReorderableListView(
                                  scrollController: controller.scrollController,
                                  shrinkWrap: true,
                                  padding:
                                      EdgeInsets.only(top: 5.h, bottom: 10.h),
                                  onReorder: (oldIndex, newIndex) {
                                    if (!controller.shiftStatus) {
                                      showSnackBar(
                                        title: 'Alert',
                                        msg:
                                            "You are not shift in. Please make shift in and try again!",
                                      );
                                      return;
                                    }

                                    int firstListLength =
                                        controller.filteredDriverList.length;

                                    if (oldIndex < firstListLength &&
                                        newIndex < firstListLength) {
                                      // Reordering within the first list
                                      controller.reorderFirstList(
                                          oldIndex, newIndex);
                                    } else if (oldIndex >= firstListLength &&
                                        newIndex >= firstListLength) {
                                      // Reordering within the second list
                                      controller.reorderSecondList(
                                        oldIndex - firstListLength,
                                        newIndex - firstListLength,
                                      );
                                    } else {
                                      if (oldIndex < firstListLength) {
                                        // Moving from list 1 to list 2
                                        controller.moveFromFirstToSecondList(
                                            oldIndex,
                                            newIndex - firstListLength);
                                      } else {
                                        // Moving from list 2 to list 1
                                        controller.moveFromSecondToFirstList(
                                            oldIndex - firstListLength,
                                            newIndex);
                                      }
                                    }
                                  },
                                  children: [
                                    // First Driver List
                                    for (int index = 0;
                                        index <
                                            controller
                                                .filteredDriverList.length;
                                        index++)
                                      AnimatedContainer(
                                        key: Key(
                                            'first_${controller.filteredDriverList[index].driverId}'),
                                        // Unique key for the first list
                                        duration:
                                            const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                          color: controller.highlightedColor(
                                                  controller.filteredDriverList[
                                                      index])
                                              ? AppColors
                                                  .kPrimaryTransparentColor
                                                  .value
                                                  .withOpacity(0.25)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.r)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 6.h,
                                            top: 6.h,
                                            left: 4.w,
                                            right: 4.w,
                                          ),
                                          child: DriverListWidget(
                                            driverDetails: controller
                                                .filteredDriverList[index],
                                            position: (index + 1),
                                            onTap: () {
                                              if (!controller.shiftStatus) {
                                                showSnackBar(
                                                  title: 'Alert',
                                                  msg:
                                                      "You are not shift in. Please make shift in and try again!",
                                                );
                                              } else {
                                                controller
                                                    .callDriverQueuePositionApi(
                                                  driverDetails: controller
                                                          .filteredDriverList[
                                                      index],
                                                );
                                              }
                                            },
                                            removeDriver: () {
                                              if (!controller.shiftStatus) {
                                                showSnackBar(
                                                  title: 'Alert',
                                                  msg:
                                                      "You are not shift in. Please make shift in and try again!",
                                                );
                                              } else {
                                                controller
                                                    .showRemoveDriverAlert(
                                                  driverDetails: controller
                                                          .filteredDriverList[
                                                      index],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),

                                    // Second Driver List
                                    for (int index = 0;
                                        index <
                                            controller
                                                .filteredSecondaryDriverList
                                                .length;
                                        index++)
                                      AnimatedContainer(
                                        key: Key(
                                            'second_${controller.filteredSecondaryDriverList[index].driverId}'),
                                        // Unique key for the second list
                                        duration:
                                            const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                          color: controller.highlightedColor(
                                                  controller
                                                          .filteredSecondaryDriverList[
                                                      index])
                                              ? AppColors
                                                  .kPrimaryTransparentColor
                                                  .value
                                                  .withOpacity(0.25)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.r)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 6.h,
                                            top: 6.h,
                                            left: 4.w,
                                            right: 4.w,
                                          ),
                                          child: DriverListWidget(
                                            driverDetails: controller
                                                    .filteredSecondaryDriverList[
                                                index],
                                            position: (index + 1),
                                            onTap: () {
                                              if (!controller.shiftStatus) {
                                                showSnackBar(
                                                  title: 'Alert',
                                                  msg:
                                                      "You are not shift in. Please make shift in and try again!",
                                                );
                                              } else {
                                                controller
                                                    .callDriverQueuePositionApi(
                                                  driverDetails: controller
                                                          .filteredSecondaryDriverList[
                                                      index],
                                                );
                                              }
                                            },
                                            removeDriver: () {
                                              if (!controller.shiftStatus) {
                                                showSnackBar(
                                                  title: 'Alert',
                                                  msg:
                                                      "You are not shift in. Please make shift in and try again!",
                                                );
                                              } else {
                                                controller
                                                    .showRemoveDriverAlert(
                                                  driverDetails: controller
                                                          .filteredSecondaryDriverList[
                                                      index],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                )*/
                              ReorderableListView(
                                  scrollController: controller.scrollController,
                                  shrinkWrap: true,
                                  padding:
                                      EdgeInsets.only(top: 5.h, bottom: 10.h),
                                  onReorder: (oldIndex, newIndex) {
                                    if (!controller.shiftStatus) {
                                      showSnackBar(
                                        title: 'Alert',
                                        msg:
                                            "You are not shift in. Please make shift in and try again!",
                                      );
                                      return;
                                    }

                                    int firstListLength =
                                        controller.filteredDriverList.length;

                                    if (oldIndex < firstListLength &&
                                        newIndex < firstListLength) {
                                      // Reordering within the first list
                                      controller.reorderFirstList(
                                          oldIndex, newIndex);
                                    } else if (oldIndex >= firstListLength &&
                                        newIndex >= firstListLength) {
                                      // Reordering within the second list
                                      controller.reorderSecondList(
                                        oldIndex - firstListLength,
                                        newIndex - firstListLength,
                                      );
                                    } else {
                                      if (oldIndex < firstListLength) {
                                        // Moving from list 1 to list 2
                                        controller.moveFromFirstToSecondList(
                                            oldIndex,
                                            newIndex - firstListLength);
                                      } else {
                                        // Moving from list 2 to list 1
                                        controller.moveFromSecondToFirstList(
                                            oldIndex - firstListLength,
                                            newIndex);
                                      }
                                    }
                                  },
                                  children: [
                                    // Title for the First Driver List
                                    Padding(
                                      key: Key(controller
                                          .generateRandomInteger(10000)
                                          .toString()),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: const Text(
                                        "Main Drivers Queue",
                                        style: TextStyle(
                                          color: Colors.white,
                                          // Change to your desired color
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),

                                    // First Driver List
                                    for (int index = 0;
                                        index <
                                            controller
                                                .filteredDriverList.length;
                                        index++)
                                      AnimatedContainer(
                                        key: Key(
                                            'first_${controller.filteredDriverList[index].driverId}'),
                                        duration:
                                            const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                          color: controller.highlightedColor(
                                                  controller.filteredDriverList[
                                                      index])
                                              ? AppColors
                                                  .kPrimaryTransparentColor
                                                  .value
                                                  .withOpacity(0.25)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.r)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 6.h,
                                            top: 6.h,
                                            left: 4.w,
                                            right: 4.w,
                                          ),
                                          child: DriverListWidget(
                                            driverDetails: controller
                                                .filteredDriverList[index],
                                            position: (index + 1),
                                            onTap: () {
                                              if (!controller.shiftStatus) {
                                                showSnackBar(
                                                  title: 'Alert',
                                                  msg:
                                                      "You are not shift in. Please make shift in and try again!",
                                                );
                                              } else {
                                                controller
                                                    .callDriverQueuePositionApi(
                                                  driverDetails: controller
                                                          .filteredDriverList[
                                                      index],
                                                );
                                              }
                                            },
                                            removeDriver: () {
                                              if (!controller.shiftStatus) {
                                                showSnackBar(
                                                  title: 'Alert',
                                                  msg:
                                                      "You are not shift in. Please make shift in and try again!",
                                                );
                                              } else {
                                                controller
                                                    .showRemoveDriverAlert(
                                                  driverDetails: controller
                                                          .filteredDriverList[
                                                      index],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),

                                    // Separator or title for the Second Driver List
                                    Padding(
                                      key: Key(controller
                                          .generateRandomInteger(10000)
                                          .toString()),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: const Text(
                                        "Secondary Drivers Queue",
                                        style: TextStyle(
                                          color: Colors.white,
                                          // Change to your desired color
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),

                                    // Second Driver List
                                    for (int index = 0;
                                        index <
                                            controller
                                                .filteredSecondaryDriverList
                                                .length;
                                        index++)
                                      AnimatedContainer(
                                        key: Key(
                                            'second_${controller.filteredSecondaryDriverList[index].driverId}'),
                                        duration:
                                            const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                          color: controller.highlightedColor(
                                                  controller
                                                          .filteredSecondaryDriverList[
                                                      index])
                                              ? AppColors
                                                  .kPrimaryTransparentColor
                                                  .value
                                                  .withOpacity(0.25)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.r)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 6.h,
                                            top: 6.h,
                                            left: 4.w,
                                            right: 4.w,
                                          ),
                                          child: DriverListWidget(
                                            driverDetails: controller
                                                    .filteredSecondaryDriverList[
                                                index],
                                            position: (index + 1),
                                            onTap: () {
                                              if (!controller.shiftStatus) {
                                                showSnackBar(
                                                  title: 'Alert',
                                                  msg:
                                                      "You are not shift in. Please make shift in and try again!",
                                                );
                                              } else {
                                                controller
                                                    .callDriverQueuePositionApi(
                                                  driverDetails: controller
                                                          .filteredSecondaryDriverList[
                                                      index],
                                                );
                                              }
                                            },
                                            removeDriver: () {
                                              if (!controller.shiftStatus) {
                                                showSnackBar(
                                                  title: 'Alert',
                                                  msg:
                                                      "You are not shift in. Please make shift in and try again!",
                                                );
                                              } else {
                                                controller
                                                    .showRemoveDriverAlert(
                                                  driverDetails: controller
                                                          .filteredSecondaryDriverList[
                                                      index],
                                                );
                                              }
                                            },
                                          ),
                                        ),
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
                                          fontWeight: FontWeight.bold,
                                        ),
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
