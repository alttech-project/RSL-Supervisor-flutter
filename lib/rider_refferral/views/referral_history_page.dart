import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../controllers/rider_refferal_controller.dart';

class RiderReferralHistoryPage extends GetView<RiderRefferalController> {
  const RiderReferralHistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Referral History",
          style: TextStyle(
            color: AppColors.kPrimaryColor.value,
            fontWeight: AppFontWeight.bold.value,
          ),
        ),
      ),
      body: controller.referralHistory.isEmpty
          ?  Padding(
              padding: const EdgeInsets.all(10),
              child: EmptyInvitesMessage(),
            )
          : ListView.builder(
              itemCount: controller.referralHistory.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final referralHistoryList = controller.referralHistory[index];
                return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.kPrimaryColor.value,
                                radius: 29.r,
                              ),
                              Text(
                                referralHistoryList.name != null &&
                                        referralHistoryList.name!.isNotEmpty
                                    ? referralHistoryList.name![0].toUpperCase()
                                    : "", // Check if the name is not empty before applying uppercase
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: AppFontWeight.bold.value,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10.w),
                         Expanded(flex: 2,child:
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             SizedBox(
                               height: 6.h,
                             ),
                             Text(
                               referralHistoryList.name ?? "",
                               style: const TextStyle(
                                 fontSize: 18,
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                             SizedBox(height: 5.h),
                             Text(
                               "+971 ${referralHistoryList.phone}",
                               style: const TextStyle(
                                 fontSize: 16,
                                 color: Colors.white54,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                             SizedBox(height: 5.h),
                             Text(
                               _amount(index),
                               style: const TextStyle(
                                 fontSize: 16,
                                 color: Colors.white54,
                                 fontWeight: FontWeight.bold,
                               ),
                               overflow: TextOverflow.ellipsis,
                               maxLines: 1,
                             ),
                             SizedBox(height: 10.h),
                           ],
                         ),),

                          Expanded(flex:1,child:
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: controller.referralHistory[index]
                                          .referralAmountUsed ==
                                      1
                                  ? const Color(0xFF006625)
                                  : Colors.yellow,
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the border radius
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              _amountStatus(index),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.white54,
                        thickness: 1.0,
                      ),
                    ]));
              },
            ),
    );
  }

  String _amount(int index) {
    final int = controller.referralHistory[index].referralAmountUsed;
    switch (int) {
      case 1:
        return "AED ${controller.referralHistory[index].earnedAmount} Earned";
      default:
        return " ${controller.referralHistory[index].referralDescription}";
    }
  }

  String _amountStatus(int index) {
    if (controller.referralHistory[index].referralAmountUsed == 1) {
      return "Earned";
    } else {
      return "Pending";
    }
  }
}

class EmptyInvitesMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "No invites yet",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Once someone uses your code to sign up for Rsl App, you will be able to see them here.",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
