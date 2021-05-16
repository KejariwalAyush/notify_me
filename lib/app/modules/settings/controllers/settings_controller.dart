import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  GetStorage box = GetStorage();
  RxBool notifyAll = true.obs;
  int timeInterval = 15;
  int noOfDays = 10;
  @override
  void onInit() {
    super.onInit();
    noOfDays = box.read('no_of_days') ?? 10;
    timeInterval = box.read('time_interval') ?? 15;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void onTimeIntervalChange(int time) => box.write('time_interval', time);
  void onNoofDaysChange(int time) => box.write('no_of_days', time);
  void getAllNotification(bool value) {
    box.write('notify_all', value);
    notifyAll.toggle();
  }
}
