import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/widgets/custom_button.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_textfields.dart';
import '../controllers/rider_referral_controller.dart';

class RiderReferralPage extends GetView<RiderReferralController> {
  const RiderReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Rider Referral",
          style: TextStyle(
            color: AppColors.kPrimaryColor.value,
            fontWeight: AppFontWeight.bold.value,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
    child: Obx(
    () => controller.showLoader.value
              ? const Expanded(
            child: Center(
              child: AppLoader(),
            ),
          ):Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(flex: 3, child: _phoneNumberWidget()),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.h, left: 0),
                      child: CustomButton(
                          linearColor: primaryButtonLinearColor,
                          height: 35.h,
                          padding: EdgeInsets.only(left: 6.w),
                          borderRadius: 10,
                          text: 'Refer',
                          onTap: () {
                            controller.callRideReferralMsgAPi(
                                int.parse(controller.dashBoardController
                                        .supervisorInfo.value.supervisorId ??
                                    ""),
                                controller.countryCode.value.trim(),
                                controller.phoneController.text.trim());
                          }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                "OR",
                style: TextStyle(
                  color: AppColors.kStatusBarPrimaryColor.value,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF353535),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
                margin: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your referral code",
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: AppFontWeight.bold.value,
                        fontSize: 19,
                      ),
                    ),

                         Row(
                            children: [
                              Obx(
                                () => Text(
                                  controller.promoDetails.value.referralCode ??
                                      "",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: AppFontWeight.bold.value,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              GestureDetector(
                                onTap: () {
                                  controller.shareReferralCode();
                                },
                                child: const Icon(
                                  Icons.share,
                                  size: 24.0,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "RSL Smiles",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: AppFontWeight.bold.value,
                    ),
                  ),
                  SizedBox(width: 10),
                  Image.asset(
                    'assets/rider_referral/smile.png',
                    width: 30,
                    height: 30,
                  )
                ],
              ),
              const SizedBox(height: 15),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF353535),
                  ),
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Obx(
                                    () => Text(
                                      controller.promoDetails.value.amountEarned
                                              .toString() ??
                                          "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: AppFontWeight.bold.value,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: AppFontWeight.bold.value,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.white54,
                              thickness: 0.4,
                              indent: 4.h,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Obx(
                                    () => Text(
                                      controller.promoDetails.value.amountEarned
                                              .toString() ??
                                          "",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: AppFontWeight.bold.value,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Earned',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: AppFontWeight.bold.value,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.white54,
                              thickness: 0.4,
                              indent: 4.h,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Obx(
                                    () => Text(
                                      controller.promoDetails.value.amountEarned
                                              .toString() ??
                                          "",
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontWeight: AppFontWeight.bold.value,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Pending',
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontWeight: AppFontWeight.bold.value,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.white54,
                        thickness: 0.4,
                        indent: 4.w,
                        endIndent: 4.w,
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          const SizedBox(height: 10),
                          Text("See All",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: AppFontWeight.bold.value,
                                fontSize: 17,
                              )),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              controller.callRiderReferralHistoryApi(int.parse(
                                  controller.dashBoardController.supervisorInfo
                                          .value.supervisorId ??
                                      ""));
                            },
                            child: const Icon(
                              Icons.chevron_right,
                              size: 30.0,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _phoneNumberWidget() {
    return SizedBox(
      height: 65.h,
      child: CountryCodeTextField(
        decoration: InputDecoration(
          hintText: "Phone Number",
          hintStyle: const TextStyle(color: Colors.white54),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.white54,
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.black12,
              width: 1.0,
            ),
          ),
        ),
        controller: controller.phoneController,
        hint: 'Phone Number (Optional)',
        inputLblTxt: 'Phone Number',
        inputLblStyle: AppFontStyle.subHeading(
            color: Colors.white54, size: AppFontSize.medium.value),
        keyboardType: TextInputType.text,
        onSubmit: (value) {},
        textInputAction: TextInputAction.next,
        onCountryChanged: (country) {
          controller.countryCode.value = country.dialCode;
        },
      ),
    );
  }
}
