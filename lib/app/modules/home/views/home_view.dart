import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    controller.startBegin();
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Chinh'),
        centerTitle: true,
      ),
      body: Center(
        child: TextButton(
          child: Text(
            "Nhan",
          ),
          onPressed: () {
            controller.buttonPress();
          },
        ),
      ),
    );
  }
}
