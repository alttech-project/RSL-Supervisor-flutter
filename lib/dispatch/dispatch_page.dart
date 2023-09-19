import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/dashboard/controllers/dashboard_controller.dart';
import 'package:rsl_supervisor/dashboard/widgets/locations_list_widget.dart';
import 'package:rsl_supervisor/dispatch/appbar/dispatch_app_bar.dart';
import 'package:rsl_supervisor/dispatch/controllers/dispatch_controller.dart';
import 'package:rsl_supervisor/dashboard/views/side_menu.dart';
import 'package:rsl_supervisor/widgets/custom_app_container.dart';

import '../../shared/styles/app_font.dart';
import '../../widgets/safe_area_container.dart';
import 'drop_search_bar.dart';

class DispatchPage extends GetView<DispatchController> {
  const DispatchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeAreaContainer(
      statusBarColor: Colors.black,
      themedark: true,
      child: Scaffold(
        drawer: const SideMenuPage(),
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
                    const DispatchAppBar(),
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
                    DropSearchBar(
                      pageType: 1,
                    ),
                    LocationsListWidget(
                      pageType: 1,
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
