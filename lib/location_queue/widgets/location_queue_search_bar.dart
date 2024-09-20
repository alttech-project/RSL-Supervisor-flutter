import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../controllers/location_queue_controller.dart';

class LocationQueueSearchBar extends GetView<LocationQueueController> {
  const LocationQueueSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 10.h),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // Set the border color
                width: 1, // Set the border width
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Text(
                  'Total:',
                  style: AppFontStyle.normalText(
                      color: AppColors.kStatusBarPrimaryColor.value),
                ),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      "${controller.secondaryDriverList.length + controller.driverList.length + controller.waitingDriverList.length}",
                      style: AppFontStyle.normalText(
                          color: AppColors.kPrimaryColor.value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          /*Container(
            padding: const EdgeInsets.only(left: 35),
            child: Text(
              'Driver:',
              style: AppFontStyle.normalText(
                  color: AppColors.kPrimaryColor.value,
                  weight: AppFontWeight.bold.value),
            ),
          ),*/
          Expanded(
            child: Container(
                height: 37,
                padding: const EdgeInsets.only(left: 50, right: 10),
                child: TextField(
                  controller: controller.searchController.value,
                  maxLines: 1,
                  onChanged: (value) {
                    controller.searchText.value = value;
                    controller.scrollToItem(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search...",
                    labelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                          color: Colors.grey), // Set the border color to grey
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Customize the focused border color
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                          color: Colors.grey), // Set the border color to grey
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                    suffixIcon: Obx(
                      () => controller.searchText.value.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                controller.searchText.value = "";
                                controller.searchController.value.text = "";
                                controller.callDriverListApi();
                                FocusScope.of(context).unfocus();
                              },
                            )
                          : const Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 20,
                            ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
