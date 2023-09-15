import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../trip_history/controllers/trip_history_controller.dart';
import '../../widgets/custom_button.dart';

class EditFarePage extends GetView<TripHistoryController> {
  const EditFarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 80),
              child: Text(
                'Edit Fare',
                style: TextStyle(
                  color: AppColors.kPrimaryColor.value,
                  fontWeight: AppFontWeight.bold.value,
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: AppColors.kPrimaryColor.value),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body:SingleChildScrollView (
      child:Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fare',
              style: TextStyle(
                color: AppColors.kPrimaryColor.value,
                fontWeight: AppFontWeight.bold.value,

              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.white,
              ),
              child: TextField(
                controller: controller.farEditController,
                decoration: const InputDecoration(
                  hintText: 'Enter new fare',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10)
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Comments',
              style: TextStyle(
                color: AppColors.kPrimaryColor.value,
                fontWeight: AppFontWeight.bold.value,

              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 150.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.white,

              ),
              child: TextField(
                controller: controller.commentAddController,
                decoration: const InputDecoration(
                  hintText: 'Enter Comments',
                  border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),

                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              height: 50.h,
              margin: EdgeInsets.all(10),
              child: CustomButton(
                width: double.maxFinite,
                linearColor: primaryButtonLinearColor,
                height: 38.h,
                borderRadius: 38.h / 2,
                style: AppFontStyle.body(color: Colors.white),
                text: 'Submit',
                onTap: () {
                  if (controller.farEditController.text == "") {
                    showSnackBar(
                        title: "Information", msg: "Enter Your Edited Fare");
                  } else if (controller.commentAddController.text == "") {
                    showSnackBar(
                        title: "Information", msg: "Enter Your Comments");
                  } else {
                    controller.callEditFareApi(
                        controller.commentAddController.text.trim(),
                        int.parse(controller.farEditController.text.trim()),
                        int.parse(controller.tripDetail.value.tripId ?? ''));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
