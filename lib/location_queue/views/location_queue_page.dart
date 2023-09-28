import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/location_queue/controllers/location_queue_controller.dart';
import 'package:rsl_supervisor/location_queue/widgets/driver_list_widget.dart';
import 'package:rsl_supervisor/location_queue/widgets/location_queue_app_bar.dart';
import 'package:rsl_supervisor/widgets/custom_app_container.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../utils/helpers/basic_utils.dart';

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
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey, // Set the border color
                                width: 1, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                                Obx(
                                  () => Container(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      "${controller.driverList.length}",
                                      style: AppFontStyle.subHeading(
                                          color: AppColors.kPrimaryColor.value),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 35),
                            child: Text(
                              'Driver:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.kPrimaryColor.value,
                                  fontWeight: AppFontWeight.bold.value),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.only(left: 4, right: 10),
                                child: TextField(
                                  controller: controller.searchController.value,
                                  maxLines: 1,
                                  onChanged: (value) {
                                    controller.filterDriverList(value);
                                    controller.searchText.value = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Search...",
                                    labelStyle:
                                        const TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                          color: Colors
                                              .grey), // Set the border color to grey
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // Customize the focused border color
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: const BorderSide(
                                          color: Colors
                                              .grey), // Set the border color to grey
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    suffixIcon: Obx(
                                      () => controller
                                              .searchText.value.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.clear,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                controller.searchText.value =
                                                    "";
                                                controller.searchController
                                                    .value.text = "";
                                                controller.callDriverListApi();
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                            )
                                          : const Icon(
                                              Icons.search,
                                              color: Colors.grey,
                                            ),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Obx(() => controller.filteredDriverList.isNotEmpty
                          ? ReorderableListView.builder(
                              itemCount: controller.filteredDriverList.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Colors.black,
                                  key: Key('$index'),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: DriverListWidget(
                                      driverDetails:
                                          controller.filteredDriverList[index],
                                      position: (index + 1),
                                      onTap: () {
                                        if (!controller.shiftStatus) {
                                          showSnackBar(
                                            title: 'Alert',
                                            msg:
                                                "You are not shift in.Please make shift in and try again!",
                                          );
                                        } else {
                                          if (controller.fromDashboard != 1) {
                                            controller
                                                .callDriverQueuePositionApi(
                                                    driverDetails: controller
                                                            .filteredDriverList[
                                                        index]);
                                          }
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
                                                  .filteredDriverList[index]);
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
                                  List<int> driverArray = controller
                                      .filteredDriverList
                                      .map((element) => (element.driverId ?? 0))
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
