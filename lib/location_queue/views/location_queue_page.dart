import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rsl_supervisor/location_queue/controllers/location_queue_controller.dart';
import 'package:rsl_supervisor/location_queue/widgets/driver_list_widget.dart';
import 'package:rsl_supervisor/location_queue/widgets/location_queue_app_bar.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
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
                      child: Obx(
                        () => controller.showDriverListLoader.value
                            ? const Center(
                                child: AppLoader(),
                              )
                            : controller.filteredDriverList.isNotEmpty ||
                                    controller
                                        .filteredSecondaryDriverList.isNotEmpty
                                ? Obx(
                                    () => ReorderableListView(
                                      scrollController:
                                          controller.scrollController,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(
                                          top: 5.h, bottom: 10.h),
                                        onReorder: (oldIndex, newIndex) {
                                          printLogs("reorder $oldIndex $newIndex");

                                          if (!controller.shiftStatus) {
                                            showSnackBar(
                                              title: 'Alert',
                                              msg: "You are not shift in. Please make shift in and try again!",
                                            );
                                            return;
                                          }

                                          // Determine header offset
                                          final headerOffset = 1; // Number of headers

                                          // Adjust indices for headers
                                          if (oldIndex > 0) {
                                            oldIndex -= headerOffset; // Remove header offset
                                          }
                                          if (newIndex > 0) {
                                            newIndex -= headerOffset; // Remove header offset
                                          }

                                          final firstListLength = controller.filteredDriverList.length;
                                          final secondListStart = firstListLength + headerOffset; // Adjust for headers

                                          if (oldIndex < firstListLength && newIndex < firstListLength) {
                                            // Reorder within the first list
                                            printLogs("Reorder within the first list: $oldIndex $newIndex");
                                            controller.reorderFirstList(oldIndex, newIndex);
                                          } else if (oldIndex >= secondListStart && newIndex >= secondListStart) {
                                            // Reorder within the second list
                                            final adjustedOldIndex = oldIndex - secondListStart;
                                            final adjustedNewIndex = newIndex - secondListStart;
                                            printLogs("Reorder within the second list: $adjustedOldIndex $adjustedNewIndex");
                                            controller.reorderSecondList(adjustedOldIndex, adjustedNewIndex);
                                          } else if (oldIndex < firstListLength && newIndex >= secondListStart) {
                                            // Moving from the first list to the second list (allowed)
                                            printLogs("Move from first list to second list: $oldIndex ${newIndex - secondListStart}");
                                            controller.moveFromFirstToSecondList(oldIndex, newIndex - secondListStart);
                                          } else if (oldIndex >= secondListStart && newIndex < firstListLength) {
                                            showSnackBar(
                                              title: 'Action Denied',
                                              msg: "You cannot move a secondary driver to the main drivers' list.",
                                            );
                                          }
                                        },
                                      children: [
                                        // First List Header (non-reorderable)
                                        Padding(
                                          key: const ValueKey(
                                              'main_drivers_header'),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h),
                                          child: Text(
                                            "Main Drivers Queue",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  AppFontSize.medium100.value,
                                            ),
                                          ),
                                        ),
                                        // First List Items
                                        for (int index = 0;
                                            index <
                                                controller
                                                    .filteredDriverList.length;
                                            index++)
                                          AnimatedContainer(
                                            key: ValueKey(
                                                'first_${controller.filteredDriverList[index].driverId}'),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            decoration: BoxDecoration(
                                              color: controller.highlightedColor(
                                                      controller
                                                              .filteredDriverList[
                                                          index])
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
                                                isSecondary: false,
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
                                                    controller.callDriverQueuePositionApi(
                                                        driverDetails: controller
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
                                          ),
                                        // Second List Header (non-reorderable)
                                        Padding(
                                          key: const ValueKey(
                                              'secondary_drivers_header'),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h),
                                          child: Text(
                                            "Secondary Drivers Queue",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: AppFontSize
                                                    .medium100.value),
                                          ),
                                        ),
                                        // Second List Items
                                        for (int index = 0;
                                            index <
                                                controller
                                                    .filteredSecondaryDriverList
                                                    .length;
                                            index++)
                                          AnimatedContainer(
                                            key: ValueKey(
                                                'second_${controller.filteredSecondaryDriverList[index].driverId}'),
                                            duration: const Duration(
                                                milliseconds: 300),
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
                                                isSecondary: true,
                                                driverDetails: controller
                                                        .filteredSecondaryDriverList[
                                                    index],
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
                                                        driverDetails: controller
                                                                .filteredSecondaryDriverList[
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
                                                                .filteredSecondaryDriverList[
                                                            index]);
                                                  }
                                                },
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 200.h,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No drivers available",
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
/*

ReorderableListView(
scrollController:
controller.scrollController,
shrinkWrap: true,
padding: EdgeInsets.only(
top: 5.h, bottom: 10.h),
onReorder: (oldIndex, newIndex) {
printLogs(
"reorder $oldIndex $newIndex");

if (!controller.shiftStatus) {
showSnackBar(
title: 'Alert',
msg:
"You are not shift in. Please make shift in and try again!",
);
return;
}

// Determine header offset
final headerOffset =
1; // Number of headers

// Adjust indices for headers
if (oldIndex > 0) {
oldIndex -=
headerOffset; // Remove header offset
}
if (newIndex > 0) {
newIndex -=
headerOffset; // Remove header offset
}

// Determine list boundaries
final firstListLength = controller
    .filteredDriverList.length;
final secondListStart = firstListLength +
headerOffset; // Adjust for headers

if (oldIndex < firstListLength &&
newIndex < firstListLength) {
// Reorder within the first list
printLogs(
"Reorder within the first list: $oldIndex $newIndex");
controller.reorderFirstList(
oldIndex, newIndex);
} else if (oldIndex >=
secondListStart &&
newIndex >= secondListStart) {
// Reorder within the second list
final adjustedOldIndex =
oldIndex - secondListStart;
final adjustedNewIndex =
newIndex - secondListStart;
printLogs(
"Reorder within the second list: $adjustedOldIndex $adjustedNewIndex");
controller.reorderSecondList(
adjustedOldIndex,
adjustedNewIndex);
} else if (oldIndex < firstListLength &&
newIndex >= secondListStart) {
// Move from the first list to the second list
printLogs(
"Move from first list to second list: $oldIndex ${newIndex - secondListStart}");
controller.moveFromFirstToSecondList(
oldIndex,
newIndex - secondListStart);
} else if (oldIndex >=
secondListStart &&
newIndex < firstListLength) {
// Move from the second list to the first list
printLogs(
"Move from second list to first list: ${oldIndex - secondListStart} $newIndex");
controller.moveFromSecondToFirstList(
oldIndex - secondListStart,
newIndex);
} else {
controller.moveFromSecondToFirstList(
oldIndex - secondListStart,
newIndex);
}
},
children: [
// First List Header (non-reorderable)
Padding(
key: const ValueKey(
'main_drivers_header'),
padding: EdgeInsets.symmetric(
vertical: 10.h),
child: Text(
"Main Drivers Queue",
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
fontSize:
AppFontSize.medium100.value,
),
),
),
// First List Items
for (int index = 0;
index <
controller
    .filteredDriverList.length;
index++)
AnimatedContainer(
key: ValueKey(
'first_${controller.filteredDriverList[index].driverId}'),
duration: const Duration(
milliseconds: 300),
decoration: BoxDecoration(
color: controller.highlightedColor(
controller
    .filteredDriverList[
index])
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
isSecondary: false,
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
controller.callDriverQueuePositionApi(
driverDetails: controller
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
),
// Second List Header (non-reorderable)
Padding(
key: const ValueKey(
'secondary_drivers_header'),
padding: EdgeInsets.symmetric(
vertical: 10.h),
child: Text(
"Secondary Drivers Queue",
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
fontSize: AppFontSize
    .medium100.value),
),
),
// Second List Items
for (int index = 0;
index <
controller
    .filteredSecondaryDriverList
    .length;
index++)
AnimatedContainer(
key: ValueKey(
'second_${controller.filteredSecondaryDriverList[index].driverId}'),
duration: const Duration(
milliseconds: 300),
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
isSecondary: true,
driverDetails: controller
    .filteredSecondaryDriverList[
index],
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
driverDetails: controller
    .filteredSecondaryDriverList[
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
    .filteredSecondaryDriverList[
index]);
}
},
),
),
)
],
),*/
