import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:notify_me/app/data/config/colors.dart';
import 'package:notify_me/app/data/config/theme.dart';

import 'app/data/models/center_list.dart';
import 'app/routes/app_pages.dart';

// [Android-only] This "Headless Task" is run when the Android app
// is terminated with enableHeadless: true
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

Future<void> checkAvailability() async {
  GetStorage box = GetStorage();
  var currentDistrictId = box.read('districtId');
  if (currentDistrictId != null) {
    DateTime currentdate = DateTime.now();
    for (var i = 0; i < 15; i++) {
      DateTime date = currentdate.add(Duration(days: i));
      String dateString = '${date.day}-${date.month}-${date.year}';
      final _url =
          'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$currentDistrictId&date=$dateString';
      // print(_url);
      var centerList = await http
          .get(Uri.parse(_url))
          .then((value) => CenterList.fromJson(value.body));

      bool isAvailable = centerList.centers
          .map((e) => e.sessions
              .map((e) => e.availableCapacity > 0)
              .toList()
              .contains(true))
          .contains(true);
      // if (isAvailable)
      //   print(
      //       'Vaccine Available in your district Go Book soon! on Date: ${DateFormat.yMEd().format(date)}');
      // print(
      //     'Vaccine Available in your district Go Book soon! on Date: ${DateFormat.yMEd().format(date)}');

      // if (isAvailable)
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: date.millisecondsSinceEpoch % 100,
        channelKey: 'basic_channel',
        title: 'Vaccine Slot Available',
        body: 'On ${DateFormat.yMEd().format(date)} at your District.',
        backgroundColor: lightGreen,
        notificationLayout: NotificationLayout.Messaging,
        showWhen: true,
      ));
    }

    print('bg-fetch complete............................................');
  }
}

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
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
  );
}

Future<void> initPlatformState() async {
  initializeNotification();
  // Configure BackgroundFetch.

  int status = await BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 15,
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

    checkAvailability();

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
            ledColor: Colors.white)
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

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:background_fetch/background_fetch.dart';
// import 'package:get_storage/get_storage.dart';

// // [Android-only] This "Headless Task" is run when the Android app
// // is terminated with enableHeadless: true
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   String taskId = task.taskId;
//   bool isTimeout = task.timeout;
//   if (isTimeout) {
//     // This task has exceeded its allowed running-time.
//     // You must stop what you're doing and immediately .finish(taskId)
//     print("[BackgroundFetch] Headless task timed-out: $taskId");
//     BackgroundFetch.finish(taskId);
//     return;
//   }
//   print('[BackgroundFetch] Headless event received.');
//   // Do your work here...
//   BackgroundFetch.finish(taskId);
// }

// void main() async {
//   await GetStorage.init();

//   // Enable integration testing with the Flutter Driver extension.
//   // See https://flutter.io/testing/ for more info.
//   runApp(new MyApp());

//   // Register to receive BackgroundFetch events after app is terminated.
//   // Requires {stopOnTerminate: false, enableHeadless: true}
//   BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool _enabled = true;
//   int _status = 0;
//   List<DateTime> _events = [];

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     // Configure BackgroundFetch.
//     int status = await BackgroundFetch.configure(
//         BackgroundFetchConfig(
//             minimumFetchInterval: 15,
//             stopOnTerminate: false,
//             enableHeadless: true,
//             requiresBatteryNotLow: false,
//             requiresCharging: false,
//             requiresStorageNotLow: false,
//             requiresDeviceIdle: false,
//             requiredNetworkType: NetworkType.ANY), (String taskId) async {
//       // <-- Event handler
//       // This is the fetch-event callback.
//       print("[BackgroundFetch] Event received $taskId");
//       setState(() {
//         _events.insert(0, new DateTime.now());
//       });
//       // IMPORTANT:  You must signal completion of your task or the OS can punish your app
//       // for taking too long in the background.
//       BackgroundFetch.finish(taskId);
//     }, (String taskId) async {
//       // <-- Task timeout handler.
//       // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
//       print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
//       BackgroundFetch.finish(taskId);
//     });
//     print('[BackgroundFetch] configure success: $status');
//     setState(() {
//       _status = status;
//     });

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//   }

//   void _onClickEnable(enabled) {
//     setState(() {
//       _enabled = enabled;
//     });
//     if (enabled) {
//       BackgroundFetch.start().then((int status) {
//         print('[BackgroundFetch] start success: $status');
//       }).catchError((e) {
//         print('[BackgroundFetch] start FAILURE: $e');
//       });
//     } else {
//       BackgroundFetch.stop().then((int status) {
//         print('[BackgroundFetch] stop success: $status');
//       });
//     }
//   }

//   void _onClickStatus() async {
//     int status = await BackgroundFetch.status;
//     print('[BackgroundFetch] status: $status');
//     setState(() {
//       _status = status;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(
//             title: const Text('BackgroundFetch Example',
//                 style: TextStyle(color: Colors.black)),
//             backgroundColor: Colors.amberAccent,
//             brightness: Brightness.light,
//             actions: <Widget>[
//               Switch(value: _enabled, onChanged: _onClickEnable),
//             ]),
//         body: Container(
//           color: Colors.black,
//           child: new ListView.builder(
//               itemCount: _events.length,
//               itemBuilder: (BuildContext context, int index) {
//                 DateTime timestamp = _events[index];
//                 return InputDecorator(
//                     decoration: InputDecoration(
//                         contentPadding:
//                             EdgeInsets.only(left: 10.0, top: 10.0, bottom: 0.0),
//                         labelStyle: TextStyle(
//                             color: Colors.amberAccent, fontSize: 20.0),
//                         labelText: "[background fetch event]"),
//                     child: new Text(timestamp.toString(),
//                         style: TextStyle(color: Colors.white, fontSize: 16.0)));
//               }),
//         ),
//         bottomNavigationBar: BottomAppBar(
//             child: Row(children: <Widget>[
//           RaisedButton(onPressed: _onClickStatus, child: Text('Status')),
//           Container(
//               child: Text("$_status"), margin: EdgeInsets.only(left: 20.0))
//         ])),
//       ),
//     );
//   }
// }
