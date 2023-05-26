import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_x_sample/controllers/details_controller.dart';
import 'package:get_x_sample/controllers/home_controller.dart';
import 'package:get_x_sample/views/others_page.dart';

class Home extends GetView<HomeController> {
  Home({super.key});

  static const routeName = '/home';

  final DetailsController detailsController = Get.find();

  @override
  Widget build(context) {
    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("Clicks: ${controller.count}"))),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    child: const Text("Go to Other"),
                    onPressed: () => Get.toNamed(Other.routeName),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Obx(() => Text("Name: ${detailsController.name.value}")),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        onPressed: () => controller.decrementCartCount(),
                        child: const Icon(CupertinoIcons.minus),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      FloatingActionButton(
                        onPressed: (){
    controller.incrementCartCount();
    controller.dashboardApiCall();
    },
                        child: const Icon(CupertinoIcons.add),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          _addToCartPopUp(),
          /*Obx(
            () => Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: controller.product.value.cartCount > 0,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Text(
                      'Total Item Count - ${controller.product.value.cartCount}'),
                ),
              ),
            ),
          ),*/
        ],
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
