import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:notify_me/app/data/config/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      bottomSheet: InkWell(
        onTap: () {
          try {
            launch('https://github.com/KejariwalAyush');
          } on Exception catch (e) {
            print(e);
          }
        },
        child: Container(
          height: 30,
          color: lightGreen,
          child: 'Made with ❤ by Ayush Kejariwal'
              .text
              .center
              .lg
              .bold
              .color(deepGreen)
              .make()
              .centered(),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Get.context.mediaQueryPadding.top.heightBox,
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left_rounded,
                        color: deepGreen,
                      ),
                      onPressed: () => Get.back()),
                ),
                Center(
                  child: 'Settings & Prefrences'
                      .text
                      .xl4
                      .extraBold
                      .center
                      .color(darkGreen)
                      .make(),
                ),
                Center(
                  child:
                      'Change your prefrences so we can provide you better output.'
                          .text
                          .lg
                          .center
                          .color(green)
                          .make()
                          .px4(),
                ),
              ],
            ),
          ),
          Expanded(
            child: VxArc(
              height: 45,
              edge: VxEdge.TOP,
              arcType: VxArcType.CONVEY,
              child: Container(
                padding: EdgeInsets.only(top: 50, right: 10, left: 10),
                color: paleGreen,
                width: Get.width,
                height: Get.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 'Themes'.text.xl2.make(),
                      // Obx(() => SwitchListTile(
                      //       value: darkMode.value,
                      //       onChanged: (value) {
                      //         print(value);
                      //         darkMode.update((val) {
                      //           val = value;
                      //         });
                      //         if (darkMode.value)
                      //           Get.changeThemeMode(ThemeMode.light);
                      //         else
                      //           Get.changeThemeMode(ThemeMode.dark);
                      //       },
                      //       title: 'DarkMode'.text.make(),
                      //     )),
                      // Divider(
                      //   color: deepGreen,
                      // ),
                      'Notifications'.text.xl2.make(),
                      ListTile(
                        title: 'Time Interval (minutes)'.text.make(),
                        subtitle:
                            'Time after which phone will check for updates'
                                .text
                                .make(),
                        trailing: VxStepper(
                          max: 120,
                          min: 15,
                          step: 15,
                          defaultValue: controller.timeInterval,
                          actionButtonColor: deepGreen,
                          actionIconColor: lightGreen,
                          onChange: controller.onTimeIntervalChange,
                        ),
                      ),
                      Obx(() => SwitchListTile(
                            title: 'Get All Notifications'.text.make(),
                            subtitle:
                                'Will give you all notification for every single available slot'
                                    .text
                                    .make(),
                            value: controller.notifyAll.value,
                            onChanged: controller.getAllNotification,
                          )),
                      Divider(
                        color: deepGreen,
                      ),
                      10.heightBox,
                      'Customization'.text.xl2.make(),
                      ListTile(
                        title: 'No. of Days'.text.make(),
                        subtitle: 'From today upto how many days you need data.'
                            .text
                            .make(),
                        trailing: VxStepper(
                          max: 20,
                          min: 5,
                          step: 1,
                          defaultValue: controller.noOfDays,
                          actionButtonColor: deepGreen,
                          actionIconColor: lightGreen,
                          onChange: controller.onNoofDaysChange,
                        ),
                      ),
                      Divider(
                        color: deepGreen,
                      ),
                      10.heightBox,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
