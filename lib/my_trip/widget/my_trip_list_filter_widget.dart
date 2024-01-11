import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/my_trip/controller/my_trip_list_controller.dart';
import 'package:rsl_supervisor/trip_history/controllers/trip_history_controller.dart';
import 'package:rsl_supervisor/widgets/app_textfields.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/date_selection_widget.dart';

class MyTripListFilterWidget extends GetView<MyTripListController> {
  const MyTripListFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor.value,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.only(
        top: 5.h,
        bottom: 10.h,
        left: 10.w,
        right: 10.w,
      ),
      child: Column(
        children: [
          Container(
            height: 40.h,
            margin: EdgeInsets.only(bottom: 10.h),
            child: Row(
              children: [
                _filterFields(type: 1),
                SizedBox(
                  width: 15.w,
                ),
                _filterFields(type: 2),
              ],
            ),
          ),
          _listdateFilterWidget(),
        ],
      ),
    );
  }

  Widget _filterFields({required int type}) {
    return Flexible(
      child: UnderlinedTextField(
        controller: (type == 1)
            ? controller.tripIdController
            : controller.carNoController,
        hint: (type == 1) ? "Enter trip id" : "Enter Car no",
        inputLblTxt: (type == 1) ? "Trip id" : "Car no",
        inputLblStyle: AppFontStyle.smallText(
          weight: AppFontWeight.semibold.value,
        ),
        textStyle: AppFontStyle.smallText(
          color: Colors.white,
        ),
        keyboardType: (type == 1) ? TextInputType.number : null,
        cursorColor: Colors.white,
      ),
    );
  }

  Widget _listdateFilterWidget() {
    return Row(
      children: [
        Obx(
          () => _dateWidget(
            type: "From",
            date: controller.fromDate.value,
          ),
        ),
        Obx(
          () => _dateWidget(
            type: "To",
            date: controller.toDate.value,
          ),
        ),
        const Spacer(),
        CustomButton(
          onTap: () => controller.callTripListApi(),
          height: 25.h,
          width: 70.w,
          text: "Submit",
          style: AppFontStyle.smallText(
            color: Colors.white,
            weight: AppFontWeight.semibold.value,
          ),
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _dateWidget({required String type, required DateTime date}) {
    return Flexible(
      flex: 10,
      child: InkWell(
        onTap: () {
          _showDatePickerWidget();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              Text(
                type,
                style: AppFontStyle.smallText(
                    weight: AppFontWeight.semibold.value),
              ),
              Text(
                DateFormat("MMM d, y HH:mm").format(date),
                style: AppFontStyle.smallText(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePickerWidget() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: DateRangePickerWidget(
          fromDate: controller.fromDate.value,
          toDate: controller.toDate.value,
          onClose: () {
            Get.back();
          },
          onSubmit: (fromDate, toDate) {
            Get.back();
            controller.fromDate.value = fromDate;
            controller.toDate.value = toDate;
          },
        ),
      ),
      isScrollControlled: true,
    );
  }
}
