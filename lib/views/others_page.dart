import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_x_sample/controllers/home_controller.dart';
import 'package:get_x_sample/views/details_page.dart';

class Other extends GetView<HomeController> {
  static const routeName = '/others';

  // You can ask Get to find a Controller that is being used by another page and redirect you to it.

  const Other({super.key});

  @override
  Widget build(context) {
    // Access the updated count variable
    return Scaffold(
      appBar: AppBar(
        title: const Text('Others'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${controller.count}"),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              child: const Text("Go to Details"),
              onPressed: () => Get.toNamed(DetailsPage.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
