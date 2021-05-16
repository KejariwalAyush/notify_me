import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notify_me/app/data/config/colors.dart';
import 'package:notify_me/app/data/models/center_list.dart';
import 'package:notify_me/app/modules/home/controllers/splash_screen_controller.dart';
import 'package:notify_me/app/routes/app_pages.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeView extends GetView {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashScreenController>();
    return Scaffold(
      backgroundColor: lightGreen,
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Get.context.mediaQueryPadding.top.heightBox,
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.settings_outlined,
                        color: deepGreen,
                      ),
                      onPressed: () => Get.toNamed(Routes.SETTINGS)),
                ),
                Center(
                  child:
                      'Hello 👋🏼,\nYou are in ${controller?.address?.subAdminArea ?? '...'}'
                          .text
                          .xl4
                          .extraBold
                          .center
                          .color(darkGreen)
                          .make(),
                ),
                Center(
                  child:
                      'Are you Vaccinated?\nIf no then this app will help you get slots.'
                          .text
                          .lg
                          .center
                          .color(green)
                          .make(),
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
                padding: EdgeInsets.only(
                  top: 50,
                ),
                color: paleGreen,
                width: Get.width,
                height: Get.height,
                child: ContainedTabBarView(
                  tabs: controller.datesList
                      .map((e) => DateFormat.Md().format(e).text.make())
                      .toList(),
                  views: controller.datesList
                      .map((e) => CenterListDisplay(
                            date: e,
                            controller: controller,
                          ))
                      .toList(),
                  onChange: (value) {},
                  tabBarProperties: TabBarProperties(
                      isScrollable: true,
                      labelColor: lightGreen,
                      indicatorColor: lightGreen,
                      unselectedLabelColor: deepGreen,
                      height: 40,
                      // width: Get.width,
                      alignment: TabBarAlignment.center,
                      indicator:
                          BoxDecoration(color: deepGreen.withOpacity(0.5)),
                      labelPadding: EdgeInsets.symmetric(horizontal: 10),
                      background: Container(
                        decoration: BoxDecoration(
                            color: paleGreen,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      position: TabBarPosition.bottom),
                  // onChange: (index) => print(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CenterListDisplay extends StatefulWidget {
  const CenterListDisplay({
    Key key,
    @required this.controller,
    @required this.date,
  }) : super(key: key);

  final SplashScreenController controller;
  final DateTime date;

  @override
  _CenterListDisplayState createState() => _CenterListDisplayState();
}

class _CenterListDisplayState extends State<CenterListDisplay> {
  int selectedPincode = 0;
  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<SplashScreenController>();
    return FutureBuilder<CenterList>(
      future: widget.controller.getCenterDetails(widget.date),
      builder: (BuildContext context, AsyncSnapshot<CenterList> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator().centered();
        CenterList centerList = snapshot.data;

        if (centerList.centers == null || centerList.centers.length == 0)
          return 'No Data for this day,\nSwipe left to Check previous one!'
              .text
              .center
              .red600
              .xl
              .bold
              .make()
              .centered();
        if (centerList.centers.first.sessions.first.date !=
            '${widget.date.day}-${widget.date.month > 9 ? widget.date.month : ('0' + widget.date.month.toString())}-${widget.date.year}')
          return 'No Slots Available On this day,\nSwipe to Check More!'
              .text
              .center
              .color(deepGreen)
              .xl
              .bold
              .make()
              .centered();

        List<CenterDetails> subCenterList = centerList.centers;
        if (selectedPincode != 0)
          subCenterList = centerList.centers
              .map((e) => e.pincode == selectedPincode ? e : null)
              .toList()
                ..removeWhere((element) => element == null);
        return Column(
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  InkWell(
                    splashColor: darkGreen,
                    onTap: () {
                      setState(() {
                        selectedPincode = 0;
                      });
                    },
                    child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selectedPincode == 0
                                    ? lightGreen.withOpacity(0.7)
                                    : lightGreen.withOpacity(0.2)),
                            child: 'All'.text.make())
                        .p4(),
                  ),
                  for (var pincode in centerList.centers
                      .map((e) => e.pincode)
                      .toSet()
                      .toList()
                      .sortedByNum((element) => element))
                    InkWell(
                      splashColor: darkGreen,
                      onTap: () {
                        setState(() {
                          selectedPincode = pincode;
                        });
                      },
                      child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: selectedPincode == pincode
                                      ? lightGreen.withOpacity(0.7)
                                      : lightGreen.withOpacity(0.2)),
                              child: pincode.text.make())
                          .p4(),
                    ),
                ])).p4(),
            Expanded(
              child: ListView.builder(
                itemCount: subCenterList.length,
                itemBuilder: (BuildContext context, int index) {
                  CenterDetails centerDetails = subCenterList[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: lightGreen.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: deepGreen),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: centerDetails.name.text.xl.extraBold
                                  .maxLines(1)
                                  .overflow(TextOverflow.ellipsis)
                                  .make(),
                            ),
                            centerDetails.pincode.text.medium.make(),
                          ],
                        ),
                        (centerDetails.sessions.first.date).text.make(),
                        'Available: ${centerDetails.sessions.first.availableCapacity}'
                            .text
                            .bold
                            .xl
                            .orange900
                            .make(),
                        Row(
                          children: [
                            Expanded(
                              child: (centerDetails.sessions.first.vaccine +
                                      ': ' +
                                      centerDetails.sessions.first.minAgeLimit
                                          .toString() +
                                      '+')
                                  .text
                                  .make(),
                            ),
                            (centerDetails.feeType).text.make(),
                          ],
                        )
                      ],
                    ),
                  ).px16().py4();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
