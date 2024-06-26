import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';

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
              child: _fromDatePickerTabView(context)),
          Visibility(
              visible: (widget.selectedTab == 1),
              child: _toDatePickerTabView(context)),
          _footerWidget(),
        ],
      ),
    );
  }

  Future<DateTime?> _selectTime(
      BuildContext context, DateTime selectedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: AppColors.kPrimaryColor.value,
            hintColor: AppColors.kPrimaryColor.value,
            primarySwatch: Colors.grey,
            colorScheme: ColorScheme.light(
                primary: AppColors.kPrimaryColor.value,
                secondary: AppColors.kPrimaryColor.value.withOpacity(0.5)),
            buttonBarTheme: const ButtonBarThemeData(
              buttonTextTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var yourSelectedDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (pickedTime != null) {
      var currentTime = DateTime(
        now.hour,
        now.minute,
      );
      var selectedTime = DateTime(pickedTime.hour, pickedTime.minute);

      /* printLogs(
          "hi time 1: ${currentTime.toString()} ${selectedTime.toString()} ${formattedTime24Hour} $formattedSelectedTime24Hour");
     */
      if (today == yourSelectedDate) {
        if (selectedTime.isAfter(currentTime)) {
          // printLogs("hi time 2:");
          return DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            now.hour,
            now.minute,
          );
        } else {
          // printLogs("hi time 3:");
          return DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
      } else {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
    return null;
  }

  Widget _fromDatePickerTabView(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          key: widget.key,
          focusedDay: widget.fromDate,
          firstDay: DateTime(2019),
          lastDay: DateTime.now(),
          selectedDayPredicate: (day) {
            return isSameDay(widget.fromDate, day);
          },
          calendarFormat: CalendarFormat.month,
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonDecoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(22.0),
            ),
            formatButtonTextStyle: const TextStyle(color: Colors.white),
            formatButtonShowsNext: false,
          ),
          onDaySelected: (date, events) async {
            print("hi date: ${date.toString()}");
            final dateString = date.toString();
            DateTime selectedDate = DateTime.parse(dateString);
            DateTime? selectedTime = await _selectTime(context, selectedDate);
            if (selectedTime != null) {
              setState(() {
                widget.fromDate = selectedTime;
              });
            }
          },
          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.value, shape: BoxShape.circle),
              child: Text(
                date.day.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            todayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.value.withOpacity(0.2),
                  shape: BoxShape.circle),
              child: Text(
                date.day.toString(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        /*SfDateRangePicker(
          enablePastDates: true,
          maxDate: DateTime.now(),
          // maxDate: widget.toDate.subtract(const Duration(days: 1)),
          selectionMode: DateRangePickerSelectionMode.single,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
            final dateString = args.value.toString();
            DateTime selectedDate = DateTime.parse(dateString);
            DateTime? selectedTime = await _selectTime(context, selectedDate);
            if (selectedTime != null) {
              setState(() {
                widget.fromDate = selectedTime;
              });
            }
          },
          selectionColor: AppColors.kPrimaryColor.value,
          initialSelectedDate: widget.fromDate,
        ),*/
      ],
    );
  }

  Widget _toDatePickerTabView(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          key: widget.key,
          focusedDay: widget.toDate,
          // currentDay: widget.toDate,
          firstDay: widget.fromDate,
          lastDay: DateTime.now(),
          selectedDayPredicate: (day) {
            return isSameDay(widget.toDate, day);
          },
          calendarFormat: CalendarFormat.month,
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonDecoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(22.0),
            ),
            formatButtonTextStyle: const TextStyle(color: Colors.white),
            formatButtonShowsNext: false,
          ),
          onDaySelected: (date, events) async {
            print("hi date: ${date.toString()}");
            final dateString = date.toString();
            DateTime selectedDate = DateTime.parse(dateString);
            DateTime? selectedTime = await _selectTime(context, selectedDate);
            if (selectedTime != null) {
              setState(() {
                widget.toDate = selectedTime;
              });
            }
          },
          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.value, shape: BoxShape.circle),
              child: Text(
                date.day.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            todayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.value.withOpacity(0.5),
                  shape: BoxShape.circle),
              child: Text(
                date.day.toString(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),

/*
        SfDateRangePicker(
          enablePastDates: true,
          minDate: widget.fromDate,
          maxDate: DateTime.now(),
          selectionMode: DateRangePickerSelectionMode.single,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
            final dateString = args.value.toString();
            DateTime selectedDate = DateTime.parse(dateString);
            DateTime? selectedTime = await _selectTime(context, selectedDate);
            if (selectedTime != null) {
              setState(() {
                widget.toDate = selectedTime;
              });
            }
          },
          selectionColor: AppColors.kPrimaryColor.value,
          initialSelectedDate: widget.toDate,
        ),
*/
      ],
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
          _dateWithTimeWidget(
            type: "From",
            date: widget.fromDate,
          ),
          _dateWithTimeWidget(
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

  Widget _dateWithTimeWidget({required String type, required DateTime date}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$type Date & Time: ",
            style: AppFontStyle.subHeading(
              size: AppFontSize.quarter.value,
            ),
          ),
          Text(
            DateFormat("MMM d, y HH:mm").format(date),
            style: AppFontStyle.subHeading(
              size: AppFontSize.quarter.value,
            ),
          ),
        ],
      ),
    );
  }
}
