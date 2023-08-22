import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/styles/app_color.dart';
import '../shared/styles/app_font.dart';
import 'app_textfields.dart';

class CarSearchView extends StatelessWidget {
  const CarSearchView({
    super.key,
    required this.onChanged,
    required this.showLoader,
    required this.listData,
    required this.onSelect,
    required this.noDataText,
    this.icon,
  });

  final Function(String) onChanged;
  final Function(int) onSelect;
  final bool showLoader;
  final List<String> listData;
  final String noDataText;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: _line(),
          ),
          BoxTextField(
            hintText: "Search...",
            autofocus: true,
            enable: true,
            onChanged: onChanged,
          ),
          _listWidget(),
        ],
      ),
    );
  }

  Widget _listWidget() {
    if (showLoader) {
      return Padding(
        padding: EdgeInsets.only(top: 5.h),
        child: LinearProgressIndicator(
          color: AppColors.kPrimaryColor.value,
          backgroundColor: AppColors.kPrimaryColor.value.withOpacity(0.4),
        ),
      );
    } else if (listData.isEmpty) {
      return SizedBox(
        height: 150.h,
        child: Center(
          child: Text(
            noDataText,
            style: AppFontStyle.body(),
          ),
        ),
      );
    } else if (listData.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: listData.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemBuilder: (BuildContext context, int index) {
            return _driverListRow(index);
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _driverListRow(int index) {
    return InkWell(
      onTap: () {
        onSelect(index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 10.w,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            icon ??
                Icon(
                  Icons.local_taxi,
                  size: 25.sp,
                  color: Colors.black,
                ),
            Flexible(
              child: Text(
                "  ${listData[index]}",
                style: AppFontStyle.body(
                  size: AppFontSize.small.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line() {
    return Container(
      width: 40.w,
      height: 3.h,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5.r),
      ),
    );
  }
}
