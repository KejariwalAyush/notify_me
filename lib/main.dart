import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:notify_me/app/data/config/colors.dart';
import 'package:notify_me/app/data/config/theme.dart';

import 'app/data/models/center_list.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();
  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: lightTheme,
      onInit: initPlatformState,
      themeMode: ThemeMode.system,
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 300),
    ),
  );
}

/// [Android-only] This "Headless Task" is run when the Android app
/// is terminated with `enableHeadless: true`
///
///
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  checkAvailability();
  // Do your work here...
  BackgroundFetch.finish(taskId);
}

/// All logic part of background fetch
///
///
///
Future<void> checkAvailability() async {
  GetStorage box = GetStorage();
  var currentDistrictId = box.read('districtId');
  if (currentDistrictId != null) {
    DateTime currentdate = DateTime.now();
    for (var i = 0; i < (box.read('no_of_days') ?? 10); i++) {
      DateTime date = currentdate.add(Duration(days: i));
      String dateString = '${date.day}-${date.month}-${date.year}';
      final _url =
          // 'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=453&date=20-05-2021';
          'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$currentDistrictId&date=$dateString';
      // print(_url);
      var centerList = await http
          .get(Uri.parse(_url))
          .then((value) => CenterList.fromJson(value.body));
      bool isAvailable = false;
      for (var e in centerList.centers) {
        // print('Center: ${e.name}');
        var avail = e.sessions
            .map((el) => el.availableCapacity > 0)
            .toList()
            .toSet()
            .toList();
        if (avail.contains(true)) ifAvailable(e);
        if (avail.contains(true)) isAvailable = true;
      }
      if (isAvailable) break;
    }
    print('bg-fetch complete............................................');
  }
}

/// Perform this if vaccines are available.
///
///
void ifAvailable(CenterDetails e) {
  print('Vaccine Available in your district Go Book soon! on Date: ${e.name}');
  List<Session> sessions = e.sessions
      .map((e) => e.availableCapacity > 0 ? e : null)
      .toList()
        ..removeWhere((el) => el == null);
  for (var session in sessions)
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: e.centerId,
            channelKey: 'basic_channel',
            title: 'Vaccinate at ${e.name}',
            body:
                'On ${session.date} at ${e.pincode}, ${session.availableCapacity} slots available.',
            summary: '${session.vaccine} for ${session.minAgeLimit}+',
            backgroundColor: lightGreen,
            color: deepGreen,
            displayOnBackground: true,
            displayOnForeground: false,
            customSound: 'assets/sounds/notification_fantacy.wav',
            notificationLayout: NotificationLayout.Inbox,
            showWhen: true,
            ticker: 'Vaccine Available'));
}

/// Initalization task at the start of application
///
///
Future<void> initPlatformState() async {
  initializeNotification();
  GetStorage box = GetStorage();
  // Configure BackgroundFetch.

  int status = await BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: box.read('time_interval') ?? 30,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY), (String taskId) async {
    // <-- Event handler
    // This is the fetch-event callback.
    print("[BackgroundFetch] Event received $taskId");

    await checkAvailability();

    // IMPORTANT:  You must signal completion of your task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }, (String taskId) async {
    // <-- Task timeout handler.
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
    BackgroundFetch.finish(taskId);
  });
  print('[BackgroundFetch] configure success: $status');

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
  if (Get.isBlank) return;
}

void initializeNotification() {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      // 'resource://drawable/res_app_icon',
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: deepGreen,
        )
      ]);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  AwesomeNotifications().actionStream.listen((receivedNotification) {});
}
