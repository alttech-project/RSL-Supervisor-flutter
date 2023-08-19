import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/details_controller.dart';

class DetailsPage extends GetView<DetailsController> {
  const DetailsPage({Key? key}) : super(key: key);

  static const routeName = '/detailsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Center(
        child: TextField(
          onChanged: (value) => controller.setName(value),
        ),
      ),
    );
  }
}
