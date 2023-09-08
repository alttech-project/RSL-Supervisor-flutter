/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'custom_button.dart';

// ignore: must_be_immutable
class DatePickerWidget extends StatefulWidget {
  DatePickerWidget({
    super.key,
    required this.date,
    required this.onClose,
    required void Function(DateTime date) this.onSubmit,
  });

  DateTime date;
  final Function()? onClose;
  final Function(DateTime date) onSubmit;
  int selectedTab = 0;

  @override
  State<DatePickerWidget> createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      margin: EdgeInsets.only(top: 100.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _headerWidget(),
          Visibility(
              visible: (widget.selectedTab == 0), child: _datePickerTabView()),
          _footerWidget(),
        ],
      ),
    );
  }

  Widget _datePickerTabView() {
    return SfDateRangePicker(
      enablePastDates: true,
      maxDate: widget.toDate.subtract(const Duration(days: 1)),
      selectionMode: DateRangePickerSelectionMode.single,
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        final dateString = args.value.toString();
        setState(() {
          widget.date = DateTime.parse(dateString);
        });
      },
      selectionColor: AppColors.kPrimaryColor.value,
      initialSelectedDate: widget.date,
    );
  }

  Widget _headerWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          InkWell(
            onTap: widget.onClose,
            child: Icon(
              Icons.close,
              size: 22.r,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          Text(
            "Select Date",
            style: AppFontStyle.subHeading(),
          )
        ],
      ),
    );
  }

  Widget _footerWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          _dateWidget(
            type: "Date",
            date: widget.date,
          ),
          const Spacer(),
          CustomButton(
            onTap: () {
              widget.onSubmit(widget.date);
              */
/* if (widget.date.isAfter(widget.toDate)) {
                showSnackBar(
                  title: "Alert",
                  msg: "From date cannot be less than to date",
                );
              } else {
                widget.onSubmit(widget.date);
              }*//*

            },
            height: 30.h,
            width: 80.w,
            text: "Submit",
            style: AppFontStyle.body(
              size: AppFontSize.small.value,
              color: Colors.white,
              weight: AppFontWeight.semibold.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateWidget({required String type, required DateTime date}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$type: ",
            style: AppFontStyle.body(
              weight: AppFontWeight.semibold.value,
            ),
          ),
          Text(
            DateFormat("MMM d, y").format(date),
            style: AppFontStyle.body(
              size: AppFontSize.small.value,
            ),
          ),
        ],
      ),
    );
  }
}
*/
