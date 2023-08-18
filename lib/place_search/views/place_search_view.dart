import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/place_search/controller/place_search_controller.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';

import '../widgets/place_search_bar.dart';

class PlaceSearchPage extends GetView<PlaceSearchController> {
  const PlaceSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeAreaContainer(
      themedark: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 6.h,
            ),
            const PlaceSearchBar(),
            Obx(
              () => Visibility(
                visible: controller.apiLoading.value,
                child: SizedBox(
                  height: 4,
                  child: LinearProgressIndicator(
                    color: AppColors.kPrimaryColor.value,
                  ),
                ),
              ),
            ),
            Obx(
              () => ListView.separated(
                itemCount: controller.predictionList.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                itemBuilder: (context, index) {
                  final prediction = controller.predictionList[index];
                  return InkWell(
                    onTap: () =>
                        controller.callPlaceDetailsApi('${prediction.placeId}'),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16.sp,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 16),
                            child: Text(
                              prediction.description ?? '',
                              style: AppFontStyle.body(
                                  color: Colors.grey.shade800,
                                  size: AppFontSize.medium.value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Divider(
                      height: 0.8,
                      thickness: 0.5,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
