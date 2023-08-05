/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/menu_controller.dart';
import '../../shared/styles/app_style.dart';
import '../../shared/styles/colors.dart';
import '../../utils/assets/assets.dart';

class SideMenuBg extends GetView<SideMenuController> {
  final VoidCallback closeMenu;

  const SideMenuBg({
    super.key,
    required this.closeMenu,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        InkWell(
          onTap: closeMenu,
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.grey.withOpacity(0.1),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.all(0.r),
            child: Container(
              width: size.width / 1.4,
              height: size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  bottomLeft: Radius.circular(10.r),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3), blurRadius: 5),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _menuItemAccount(
                        title: 'Account',
                        image: 'lib/app/assets/user.png',
                      ),
                      SizedBox(height: 15.h),
                      _menuContainer1(),
                     *//* SizedBox(height: 15.h),
                      _menuContainer2(),
                      SizedBox(height: 15.h),
                      _menuContainer3(),
                      SizedBox(height: 15.h),
                     _menuContainer4(),
                      _logOut(controller),*//*
                      SizedBox(height: 50.h),
                      _appVersionWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _logOut(SideMenuController controller) {
    return Obx(
      () => controller.userId.value != ''
          ? _logInLogoutWidget(
              onTap: () => controller.logout(),
              text: "Log out",
              icon: Icons.logout,
            )
          : _logInLogoutWidget(
              onTap: () {
                Get.toNamed(AppRoutes.loginScreen);
                pageFrom = LoginRequestedType.kOthers;
                controller.hideMenu();
              },
              text: "Login",
              icon: Icons.login,
            ),
    );
  }

  Widget _logInLogoutWidget(
          {required VoidCallback onTap,
          required String text,
          required IconData icon}) =>
      Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 18.w, right: 10.w, bottom: 6.h),
            child: Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: AppFontWeight.normal.value,
                    fontSize: AppFontSize.large.value,
                  ),
                ),
                const Spacer(),
                Icon(
                  icon,
                  color: AppColor.kLightTextSecondary.value,
                )
              ],
            ),
          ),
        ),
      );

  Widget _menuContainer1() {
    return _menuItemContainer(
      items: [
        _menuRowItem(
          title: 'Profile',
        ),
        _menuRowItem(
            title: 'My Bookings',
            onTap: () {
              if (controller.userId.value != '') {
                Get.toNamed(AppRoutes.bookingsTabview);
                controller.hideMenu();
              } else {
                Get.toNamed(AppRoutes.loginScreen);
                pageFrom = LoginRequestedType.kMyBookings;
                controller.hideMenu();
              }
            }),
        _menuRowItem(
          title: 'Wishlist',
        ),
        _menuRowItem(
          title: 'RSL Wallet',
        ),
      ],
    );
  }

  Widget _menuContainer2() {
    return _menuItemContainer(
      items: [
        _menuRowItem(
          title: 'Start Earning',
          onTap: () {
            Get.toNamed(AppRoutes.startEarningPage);
          }
        ),
        _menuRowItem(
          title: 'Corporate Partner',
          onTap: () {
            Get.toNamed(AppRoutes.corporatePartnerPage);
          }
        ),
        _menuRowItem(
          title: 'Transport Partner',
            onTap: () {
              Get.toNamed(AppRoutes.transportPartnerPage);
            }

        ),

      ],
    );
  }

  Widget _menuContainer3() {
    return _menuItemContainer(
      items: [
        _menuRowItem(
          title: 'Region',
        ),
        _menuRowItem(
          title: 'Currency',
        ),
        _menuRowItem(
          title: 'Language',
        ),
        _menuRowItem(
          title: 'Payment Types',
        ),
      ],
    );
  }




  Widget _menuContainer4() {
    return _menuItemContainer(
      items: [
        _menuRowItem(
          title: 'Help Center',
        ),
        _menuRowItem(
          title: 'careers',
        ),
        _menuRowItem(
          title: 'Qibla & Prayer Times',
        ),
        _menuRowItem(
          title: 'Legal Information',
        ),
      ],
    );
  }

  Container _menuItemContainer({required List<Widget> items}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.kSecondaryBackGroundColor.value,
        borderRadius: BorderRadius.all(
          Radius.circular(5.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          children: items,
        ),
      ),
    );
  }

  Widget _menuRowItem({required String title, VoidCallback? onTap}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: AppFontWeight.normal.value,
                    fontSize: AppFontSize.large.value,
                  ),
                ),
              ),
              const Spacer(),
              Image.asset(
                Assets.rightArror,
                height: 8.h,
                width: 10.w,
                color: AppColor.kPrimaryTextColor.value,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItemAccount({required String title, required String image}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          Assets.person,
          width: 40.w,
          height: 30.h,
          fit: BoxFit.cover,
          color: AppColor.kPrimaryColor.value,
        ),

        //Icon(Icons.person,size: 22.r,color: AppColor.kPrimaryColor.value,),

        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontWeight: AppFontWeight.semibold.value,
            fontSize: AppFontSize.medium.value,
          ),
        )
      ],
    );
  }

  Widget _appVersionWidget() {
    return Obx(
      () => (controller.appVersion.value == '')
          ? const SizedBox.shrink()
          : Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Version ${controller.appBuildNumber.value}(${controller.appVersion.value})",
                style: TextStyle(
                  fontWeight: AppFontWeight.medium.value,
                  fontSize: AppFontSize.verySmall.value,
                  color: Colors.cyan,
                ),
              ),
            ),
    );
  }
}*/
