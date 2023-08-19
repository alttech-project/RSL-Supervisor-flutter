import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/location_queue/controllers/location_queue_controller.dart';
import 'package:rsl_supervisor/location_queue/widgets/driver_list_widget.dart';
import 'package:rsl_supervisor/widgets/custom_app_container.dart';
import 'package:rsl_supervisor/widgets/navigation_title.dart';

import '../../widgets/safe_area_container.dart';

class LocationQueuePage extends GetView<LocationQueueController> {
  const LocationQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CommonAppContainer(
        showLoader: controller.showLoader.value,
        child: SafeAreaContainer(
          statusBarColor: Colors.black,
          themedark: true,
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
                    left: 10.w, right: 10.w, top: 24.h, bottom: 12.h),
                child: Column(
                  children: [
                    NavigationBarWithIcon(
                      onTap: () => controller.goBack(),
                    ),
                    const AddCarBtnWidget(),
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
                                  controller.callDriverQueuePositionApi(
                                      driverDetails:
                                          controller.driverList[index]);
                                },
                                removeDriver: () {
                                  controller.callAddDriverApi(
                                      driverDetails:
                                          controller.driverList[index],
                                      type: 2);
                                },
                              ),
                            ),
                          );
                        },
                        onReorder: ((oldIndex, newIndex) {
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
}
