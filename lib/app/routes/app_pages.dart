import 'package:get/get.dart';

import 'package:notify_me/app/modules/home/bindings/home_binding.dart';
import 'package:notify_me/app/modules/home/views/home_view.dart';
import 'package:notify_me/app/modules/home/views/splash_screen_view.dart';
import 'package:notify_me/app/modules/settings/bindings/settings_binding.dart';
import 'package:notify_me/app/modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreenView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
