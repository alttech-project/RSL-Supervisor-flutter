import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/place_search/controller/place_search_controller.dart';

import '../../supporting_classes/app_color.dart';
import '../../supporting_classes/app_font.dart';

class PlaceSearchBar extends GetView<PlaceSearchController> {
  const PlaceSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Icon(
                  Icons.arrow_back,
                  size: 22.sp,
                  color: AppColors.kPrimaryColor.value,
                ),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: 40.h,
                child: Center(
                  child: TextField(
                    controller: controller.searchController.value,
                    onChanged: (text) {
                      controller.callPlacesListApi(text);
                    },
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      border: InputBorder.none,
                    ),
                    style: AppFontStyle.body(),
                    autofocus: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
