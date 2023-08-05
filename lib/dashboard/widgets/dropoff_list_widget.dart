import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../supporting_classes/app_color.dart';
import '../../supporting_classes/app_font.dart';
import '../controllers/dashboard_controller.dart';

class DropoffListWidget extends GetView<DashBoardController> {
  const DropoffListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.dropOffList.isEmpty)
          ? Center(
              child: SizedBox(
                height: 300,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.noDropOffDataMsg.value,
                          style: AppFontStyle.subHeading(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: controller.dropOffList.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.only(
                top: 20,
              ),
              itemBuilder: (BuildContext context, int index) {
                final dropOff = controller.dropOffList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor.value,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      child: Row(
                        children: [
                          Text(
                            dropOff.address ?? "",
                            style: AppFontStyle.body(
                              weight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            dropOff.fare ?? "",
                            style: AppFontStyle.body(
                              weight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
