import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/driver_list/controller/driver_list_controller.dart';
import 'package:rsl_supervisor/driver_list/data/driver_list_api_data.dart';
import 'package:rsl_supervisor/driver_list/view/driver_list_app_bar.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';
import '../../shared/styles/app_font.dart';
import '../../widgets/app_loader.dart';

class DriverListScreen extends GetView<DriverListController> {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.black,
            body: Column(
              children: [
                const DriverListAppBar(),
                Obx(() => Expanded(
                      child: (controller.apiLoading.value)
                          ? const Center(
                              child: AppLoader(),
                            )
                          : (controller.driverList.isNotEmpty)
                              ? Flexible(
                                  child: ListView.separated(
                                    itemCount: controller.driverList.length,
                                    itemBuilder: (context, index) {
                                      return DriverListItem(
                                        driverData:
                                            controller.driverList[index],
                                        key: Key('$index'),
                                      );
                                    },
                                    separatorBuilder: (context, position) {
                                      return const Divider(color: Colors.grey);
                                    },
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    controller.noDataMsg.value,
                                    style: AppFontStyle.body(
                                      color: Colors.white,
                                      weight: AppFontWeight.semibold.value,
                                    ),
                                  ),
                                ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DriverListItem extends StatelessWidget {
  const DriverListItem({required Key key, required this.driverData})
      : super(key: key);
  final DriverList driverData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Car Plate: ${driverData.taxiNo.toString()}",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text("Driver Name: ${driverData.driverName}",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text("Driver Phone: ${driverData.driverPhone}",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ]),
    );
  }
}
