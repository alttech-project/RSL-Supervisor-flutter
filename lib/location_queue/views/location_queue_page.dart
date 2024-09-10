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
                              ?

                      ReorderableListView(
                        scrollController: controller.scrollController,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 5.h, bottom: 10.h),
                        onReorder: (oldIndex, newIndex) {
                          if (!controller.shiftStatus) {
                            showSnackBar(
                              title: 'Alert',
                              msg: "You are not shifted in. Please make shift in and try again!",
                            );
                          } else {
                            List<int> driverArray = controller.filteredDriverList
                                .map((element) => element.driverId ?? 0)
                                .toList();
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final int item = driverArray.removeAt(oldIndex);
                            driverArray.insert(newIndex, item);
                            controller.callUpdateDriverQueueApi(driverArray: driverArray);
                          }
                        },
                        children: <Widget>[
                          // Section 1 Header
                          Container(
                            key: ValueKey('section1_header'),
                            padding: EdgeInsets.all(8.0),
                            width: double.infinity, // Ensure the container takes full width
                            child: Center(
                              child: Text(
                                'Main Drivers Queue',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          // Section 1 Items
                          ...controller.filteredDriverList
                              .where((item) => /* Your condition for main drivers */ true)
                              .map((item) => ReorderableDragStartListener(
                            key: ValueKey('main_driver_${item.driverId}'),
                            index: controller.filteredDriverList.indexOf(item),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              key: Key(item.driverId.toString()),
                              decoration: BoxDecoration(
                                color: controller.highlightedColor(item)
                                    ? AppColors.kPrimaryTransparentColor.value.withOpacity(0.25)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 6.h, top: 6.h, left: 4.w, right: 4.w),
                                child: DriverListWidget(
                                  driverDetails: item,
                                  position: (controller.filteredDriverList.indexOf(item) + 1),
                                  onTap: () {
                                    if (!controller.shiftStatus) {
                                      showSnackBar(
                                        title: 'Alert',
                                        msg: "You are not shifted in. Please make shift in and try again!",
                                      );
                                    } else {
                                      controller.callDriverQueuePositionApi(driverDetails: item);
                                    }
                                  },
                                  removeDriver: () {
                                    if (!controller.shiftStatus) {
                                      showSnackBar(
                                        title: 'Alert',
                                        msg: "You are not shifted in. Please make shift in and try again!",
                                      );
                                    } else {
                                      controller.showRemoveDriverAlert(driverDetails: item);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ))
                              .toList(),

                        Container(
                            key: ValueKey('section2_header'),
                            padding: EdgeInsets.all(8.0),
                            width: double.infinity, // Ensure the container takes full width
                            child: Center(
                              child: Text(
                                'Secondary Drivers Queue',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          // Section 2 Items
                          ...controller.filteredDriverList
                              .where((item) => /* Your condition for secondary drivers */ true)
                              .map((item) => ReorderableDragStartListener(
                            key: ValueKey('secondary_driver_${item.driverId}'),
                            index: controller.filteredDriverList.indexOf(item),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              key: Key(item.driverId.toString()),
                              decoration: BoxDecoration(
                                color: controller.highlightedColor(item)
                                    ? AppColors.kPrimaryTransparentColor.value.withOpacity(0.25)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 6.h, top: 6.h, left: 4.w, right: 4.w),
                                child: DriverListWidget(
                                  driverDetails: item,
                                  position: (controller.filteredDriverList.indexOf(item) + 1),
                                  onTap: () {
                                    if (!controller.shiftStatus) {
                                      showSnackBar(
                                        title: 'Alert',
                                        msg: "You are not shifted in. Please make shift in and try again!",
                                      );
                                    } else {
                                      controller.callDriverQueuePositionApi(driverDetails: item);
                                    }
                                  },
                                  removeDriver: () {
                                    if (!controller.shiftStatus) {
                                      showSnackBar(
                                        title: 'Alert',
                                        msg: "You are not shifted in. Please make shift in and try again!",
                                      );
                                    } else {
                                      controller.showRemoveDriverAlert(driverDetails: item);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ))
                              .toList(),
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
