import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:notify_me/app/data/config/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
                child: VxTicket(
              backgroundColor: green,
              isTwoSided: true,
              height: 300,
              isHardEdged: false,
              width: Get.width,
              child: Center(
                child: 'Get Notified of the Vaccine slots in your Area'
                    .text
                    .bold
                    .lg
                    .xl
                    .center
                    .color(lightGreen)
                    .make()
                    .p16(),
              ),
            ).p32()),
          ),
          Center(child: CircularProgressIndicator().p24()),
          Center(
              child:
                  controller?.address?.countryName ?? 'Loading...'.text.make()),
        ],
      ),
    );
  }
}
