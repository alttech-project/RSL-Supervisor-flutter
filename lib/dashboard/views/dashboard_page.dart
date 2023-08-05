import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/common_widgets/app_textfields.dart';
import 'package:rsl_supervisor/dashboard/controllers/dashboard_controller.dart';
import 'package:rsl_supervisor/dashboard/widgets/dropoff_list_widget.dart';
import 'package:rsl_supervisor/supporting_classes/app_color.dart';

import '../../supporting_classes/app_font.dart';
import '../widgets/dashboard_appbar.dart';

class DashboardPage extends GetView<DashBoardController> {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              const DashboardAppBar(),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Tidel Park Coimbatore - 2",
                  style: AppFontStyle.subHeading(
                    color: AppColors.kPrimaryColor.value,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "RSL Test",
                  style: AppFontStyle.subHeading(
                    color: AppColors.kPrimaryColor.value,
                  ),
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Use Custom Drop Off',
                    style: AppFontStyle.subHeading(color: Colors.white),
                  ),
                  Obx(
                    () => Switch(
                      value: controller.useCustomDrop.value,
                      inactiveTrackColor: Colors.red.shade300,
                      inactiveThumbColor: Colors.red.shade800,
                      activeColor: Colors.green,
                      onChanged: (bool newValue) {
                        controller.customDropAction(newValue);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Text(
                      'Drop Off:  ',
                      style: AppFontStyle.subHeading(
                          color: AppColors.kPrimaryColor.value),
                    ),
                    Flexible(
                      child: CapsuleTextField(
                        controller: controller.searchController.value,
                        hint: "Search...",
                      ),
                    ),
                  ],
                ),
              ),
              const DropoffListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
