import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/controllers/home_controller.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';

class Home extends GetView<HomeController> {
  Home({super.key});

  static const routeName = '/home';

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: SafeAreaContainer(
        child: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: () {},
              ),
              title: Obx(() => Text("Clicks: ${controller.count}"))),

          // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
          body: const Center(
            child: Text('Home'),
          ),
        ),
      ),
    );
  }

  Widget _addToCartPopUp() {
    return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(controller.animationController),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Wrap(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 12,
                margin: const EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(Icons.add_shopping_cart),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                                "Successfully added to cart - ${controller.product.value.cartCount}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              )),
                          const SizedBox(
                            height: 4,
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Text(
                              "Go to cart",
                              style: TextStyle(
                                color: Color(0xff535960),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                          onTap: () {
                            controller.animationController.reverse();
                          },
                          child: const Icon(Icons.cancel)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
