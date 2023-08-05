import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/place_search/controller/place_search_controller.dart';
import 'package:rsl_supervisor/supporting_classes/app_font.dart';

import '../widgets/place_search_bar.dart';

class PlaceSearchPage extends GetView<PlaceSearchController> {
  const PlaceSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PlaceSearchBar(),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          Obx(
            () => ListView.builder(
              itemCount: controller.predictionList.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              itemBuilder: (context, index) {
                final prediction = controller.predictionList[index];
                return InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 22.sp,
                            color: Colors.grey.shade800,
                          ),
                          Text(
                            "  ${prediction.description ?? ''}",
                            style: AppFontStyle.body(
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          height: 0.8,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
