import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/dashboard/widgets/locations_list_widget.dart';
import 'package:rsl_supervisor/quickTrip/widgets/drop_location_search_bar.dart';
import 'package:rsl_supervisor/widgets/custom_app_container.dart';

import '../../dashboard/widgets/drop_search_bar.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/safe_area_container.dart';
import '../controllers/drop_location_controller.dart';
import '../widgets/drop_location_app_bar.dart';

class DropLocationPage extends GetView<DropLocationController> {
  const DropLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeAreaContainer(
      statusBarColor: Colors.black,
      themedark: true,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.black,
        key: controller.scaffoldKey,
        body: Obx(
          () => CommonAppContainer(
            showLoader: controller.showLoader.value,
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.w,
                right: 10.w,
                top: 24.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const DropLocationAppBar(),
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          'Use Custom Drop Off',
                          style: AppFontStyle.subHeading(color: Colors.white),
                        ),
                        SizedBox(
                          height: 30.h,
                          width: 40.w,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Switch(
                              value: controller.useCustomDrop.value,
                              inactiveTrackColor: Colors.red.shade300,
                              inactiveThumbColor: Colors.red.shade800,
                              activeColor: Colors.green,
                              onChanged: (bool newValue) {
                                controller.customDropAction(newValue);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    DropLocationSearchBar(
                      pageType: 3,
                    ),
                    LocationsListWidget(
                      pageType: 3,
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
