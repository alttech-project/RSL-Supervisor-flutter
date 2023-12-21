import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'custom_button.dart';

// ignore: must_be_immutable
class DateRangePickerWidget extends StatefulWidget {
  DateRangePickerWidget({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onClose,
    required void Function(DateTime fromDate, DateTime toDate) this.onSubmit,
  });

  DateTime fromDate;
  DateTime toDate;
  final Function()? onClose;
  final Function(DateTime fromDate, DateTime toDate) onSubmit;
  int selectedTab = 0;

  @override
  State<DateRangePickerWidget> createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
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
          ToggleButton(
            width: ScreenUtil().screenWidth * 0.80,
            height: 30.h,
            toggleBackgroundColor: Colors.white,
            toggleBorderColor: (Colors.grey[350])!,
            toggleColor: AppColors.kPrimaryColor.value,
            activeTextColor: Colors.white,
            inactiveTextColor: Colors.grey,
            leftDescription: 'From Date',
            rightDescription: 'To date',
            onLeftToggleActive: () {
              setState(() {
                widget.selectedTab = 0;
              });
            },
            onRightToggleActive: () {
              setState(() {
                widget.selectedTab = 1;
              });
            },
          ),
          Visibility(
              visible: (widget.selectedTab == 0),
              child: _fromDatePickerTabView()),
          Visibility(
              visible: (widget.selectedTab == 1),
              child: _toDatePickerTabView()),
          _footerWidget(),
        ],
      ),
    );
  }

  Widget _fromDatePickerTabView() {
    return SfDateRangePicker(
      enablePastDates: true,
      maxDate: DateTime.now(),
      // maxDate: widget.toDate.subtract(const Duration(days: 1)),
      selectionMode: DateRangePickerSelectionMode.single,
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        final dateString = args.value.toString();
        setState(() {
          widget.fromDate = DateTime.parse(dateString);
        });
      },
      selectionColor: AppColors.kPrimaryColor.value,
      initialSelectedDate: widget.fromDate,
    );
  }

  Widget _toDatePickerTabView() {
    return SfDateRangePicker(
      enablePastDates: true,
      minDate: widget.fromDate,
      maxDate: DateTime.now(),
      selectionMode: DateRangePickerSelectionMode.single,
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        final dateString = args.value.toString();
        setState(() {
          widget.toDate = DateTime.parse(dateString);
        });
      },
      selectionColor: AppColors.kPrimaryColor.value,
      initialSelectedDate: widget.toDate,
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
            "Select Dates",
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
            type: "From",
            date: widget.fromDate,
          ),
          _dateWidget(
            type: "To",
            date: widget.toDate,
          ),
          const Spacer(),
          CustomButton(
            onTap: () {
              if (widget.fromDate.isAfter(widget.toDate)) {
                showSnackBar(
                  title: "Alert",
                  msg: "From date cannot be less than to date",
                );
              } else {
                widget.onSubmit(widget.fromDate, widget.toDate);
              }
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
