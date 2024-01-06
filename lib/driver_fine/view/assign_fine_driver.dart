import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/driver_fine/data/driver_fine_data.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import '../../driver_list/data/driver_list_api_data.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_textfields.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/safe_area_container.dart';
import '../controller/driver_fine_controller.dart';

class AssignFinePage extends GetView<DriverFineController> {
  const AssignFinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    final fineType = args['fineType'] as String;
    final fineAmount = args['fineAmount'] as String;
    print("fineType-->${fineType}");
    print("fineamount-->${fineAmount}");

    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          controller.onClose();
          return Future.value(true);
        },
        child: SafeAreaContainer(
          statusBarColor: Colors.black,
          themedark: true,
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  controller.onClose();
                  Get.back();
                },
                radius: 24.r,
                child: Padding(
                  padding: EdgeInsets.all(14.r),
                  child: Icon(
                    Icons.arrow_back,
                    size: 25.sp,
                    color: AppColors.kPrimaryColor.value,
                  ),
                ),
              ),
              centerTitle: true,
              title:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    'Put Fine on Driver',
                    style: AppFontStyle.subHeading(
                      color: AppColors.kPrimaryColor.value,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 50.w),
                  CustomIconButton(
                    title: "View",
                    icon: Icons.remove_red_eye_sharp,
                    onTap: () {
                      Get.toNamed(AppRoutes.finnedDrivers);
                    }, // Use showAlertDialog here
                  )

                ],
              ),

            ),
            body: SingleChildScrollView(child:Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Column(children: [
                _labelAndTextFieldWidget(
                  "Put Fine on Driver",
                  "Put Fine on Driver",
                  "Put Fine on Driver",
                  txtEditingController: controller.fineAssignController,
                  onTap: () {
                    showDriverListBottomSheet();
                  },
                ),
                SizedBox(height: 15.h),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Notes",
                          style: AppFontStyle.subHeading(
                              color: AppColors.kPrimaryColor.value,
                              size: AppFontSize.medium.value))
                    ]),
                SizedBox(height: 15.h),
                _remarksWidget(),
                SizedBox(height: 30.h),
                CustomButton(
                  width: double.maxFinite,
                  linearColor: primaryButtonLinearColor,
                  height: 38.h,
                  borderRadius: 38.h / 2,
                  style: AppFontStyle.body(color: Colors.white),
                  text: 'Save',
                  onTap: () {
                    addFineDetailsToController(fineType,fineAmount);
                    Get.back();
                  },
                ),
              ]

              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  void addFineDetailsToController(String fineType, String fineAmount,) {
    assignedFineDetail newDetails = assignedFineDetail(
      fineType: fineType,
      fineAmount: fineAmount,
      notes: controller.notesController.text.trim(),
      assignedDrivers: controller.fineAssignController.text.trim(),
    );
    controller.assignedFineDetails(newDetails);
  }

  void showDriverListBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.95, // Adjust height as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 60.h,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Put Fine on Driver',
                      style: TextStyle(
                        fontWeight: AppFontWeight.bold.value,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const Divider(
                        color: Colors.black),
                  ],



                )
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: controller.driverList.length,
                separatorBuilder: (context, index) =>
                    Divider(), // Add Divider between items
                itemBuilder: (context, index) {
                  DriverList driver = controller.driverList[index];
                  return ListTile(
                    title: Text(
                      driver.driverName ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(driver.taxiNo ?? ''),
                    onTap: () {
                      controller.fineAssignController.text =
                          driver.driverName ?? '';
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 10, // Customize elevation
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
  Widget _remarksWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kPrimaryTransparentColor.value,
        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
      ),
      constraints: BoxConstraints(
          minHeight: 100.h, maxHeight: 120.h), // Example constraints
      child: RemarksTextFieldTransparent(
        hintText: "Enter your notes (Optional)",
        keyboardType: TextInputType.multiline,
        textController: controller.notesController,
        enable: true,
        autocorrect: false,
        textInputAction: TextInputAction.newline,
        autofocus: false,
      ),
    );
  }
  Widget _labelAndTextFieldWidget(String fieldLabel, String label, String hint,
      {Widget? suffix,
      required TextEditingController txtEditingController,
      TextInputType keyboardType = TextInputType.text,
      TextInputAction textInputAction = TextInputAction.next,
      FormFieldValidator? validator,
      bool readOnly = true,
      GestureTapCallback? onTap,
      Function(String)? onChanged,
      Color? borderColor,
      Color? focusColor,
      TextStyle? textStyle}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: UnderlinedTextField(
        controller: txtEditingController,
        hint: hint,
        inputLblTxt: label,
        inputLblStyle: AppFontStyle.subHeading(
            color: AppColors.kPrimaryColor.value,
            size: AppFontSize.medium.value),
        keyboardType: keyboardType,
        onSubmit: (value) {},
        textInputAction: textInputAction,
        suffix: suffix,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        borderColor: borderColor,
        focusColor: focusColor,
        textStyle: textStyle,
      ),
    );
  }
}
