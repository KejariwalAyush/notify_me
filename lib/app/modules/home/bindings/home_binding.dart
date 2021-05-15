import 'package:get/get.dart';
import 'package:notify_me/app/modules/home/controllers/splash_screen_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(
      () => SplashScreenController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
