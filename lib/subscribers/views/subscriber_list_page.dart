import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/widgets/app_loader.dart';
import '../controllers/subscriberpage_controller.dart';

class SubscribersPage extends GetView<SubscribersController> {
  const SubscribersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Subscribers',
          style: TextStyle(
            color: AppColors.kPrimaryColor.value,
            fontWeight: AppFontWeight.bold.value,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Set the border color
                        width: 1, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              "${controller.subscriberList.value.length}",
                              style: AppFontStyle.body(
                                  color: AppColors.kPrimaryColor.value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 35),
                    child: Text(
                      'Driver:',
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColors.kPrimaryColor.value,
                          fontWeight: AppFontWeight.bold.value),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 4, right: 10),
                        child: TextField(
                          controller: controller.searchController.value,
                          maxLines: 1,
                          onChanged: (value) {
                            controller.filterDriverList(value);
                            controller.searchText.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Search...",
                            labelStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Colors
                                      .grey), // Set the border color to grey
                            ),
                            focusedBorder: OutlineInputBorder(
                              // Customize the focused border color
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Colors
                                      .grey), // Set the border color to grey
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            suffixIcon: Obx(
                              () => controller.searchText.value.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        controller.searchText.value = "";
                                        controller.searchController.value.text =
                                            "";
                                        controller.callTaxiListApi();
                                        FocusScope.of(context).unfocus();
                                      },
                                    )
                                  : const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
              Expanded(
                child: Obx(
                  () => Column(
                    children: [
                      const SizedBox(height: 10),
                      controller.showLoader.value
                          ? const Expanded(
                              child: Center(
                                child: AppLoader(),
                              ),
                            )
                          : controller.filteredDriverList.isEmpty
                              ? Center(
                                  child: SizedBox(
                                    height: 50.h,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No Data found",
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Expanded(

                                  child: ListView.builder(
                                    itemCount:
                                        controller.filteredDriverList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final driver =
                                          controller.filteredDriverList[index];
                                      String? modelName = driver.modelName;
                                      if (modelName == "SEDAN") {
                                        modelName = "S";
                                      } else if (modelName == "VIP PLUS") {
                                        modelName = "VIP +";
                                      } else {
                                        modelName = "XL";
                                      }
                                      return Container(
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF353535),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                driver.driverName ?? '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      AppFontWeight.bold.value,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/subscriber_page/car.png',
                                                    width: 17,
                                                    height: 17,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    driver.driverPhone ?? '',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight: AppFontWeight
                                                          .bold.value,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/subscriber_page/tellephone.png',
                                                    width: 15,
                                                    height: 15,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    driver.taxiNo ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          trailing: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: AppColors
                                                    .kPrimaryColor.value,
                                                radius: 25,
                                              ),
                                              Text(
                                                modelName ?? '',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      AppFontWeight.bold.value,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
