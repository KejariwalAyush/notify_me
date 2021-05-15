import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:notify_me/app/data/models/center_list.dart';
import 'package:notify_me/app/data/models/districts_list_model.dart';
import 'package:notify_me/app/routes/app_pages.dart';
import 'package:notify_me/app/states_list_model.dart';

class SplashScreenController extends GetxController {
  Position position;
  Address address;
  int currentStateId;
  int currentDistrictId;

  List<DateTime> datesList = [
    for (var i = 0; i < 15; i++) DateTime.now().add(Duration(days: i)),
  ];

  @override
  void onInit() {
    print('init');
    getData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // Future.delayed(Duration(milliseconds: 600))
    //     .then((value) => Get.offNamed(Routes.HOME));
  }

  @override
  void onClose() {}

  void getData() async {
    await getLocation();

    printInfo(info: address.toMap().toString());
    http.Response resp = await http.get(
        Uri.parse('https://cdn-api.co-vin.in/api/v2/admin/location/states'));
    StatesList states = StatesList.fromJson(resp.body);
    currentStateId = states.states
        .singleWhere((e) =>
            (e.stateName.toLowerCase() == address.adminArea.toLowerCase()))
        .stateId;
    printInfo(info: currentStateId.toString());

    http.Response resp2 = await http.get(Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/admin/location/districts/$currentStateId'));
    DistrictList districtList = DistrictList.fromJson(resp2.body);
    currentDistrictId = districtList.districts
        .singleWhere((e) => (e.districtName.toLowerCase() ==
            address.subAdminArea.toLowerCase()))
        .districtId;
    printInfo(info: currentDistrictId.toString());

    printInfo(info: currentDistrictId.toString());

    Future.delayed(Duration(milliseconds: 600))
        .then((value) => Get.offNamed(Routes.HOME));
  }

  Future<void> getLocation() async {
    await Geolocator.requestPermission();
    position = await Geolocator.getCurrentPosition();
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(position.latitude, position.longitude));
    address = addresses.first;
  }

  Future<CenterList> getCenterDetails(DateTime date) async {
    // String dateString = DateFormat.yMd().format(date).replaceAll('/', '-');
    String dateString = '${date.day}-${date.month}-${date.year}';
    final _url =
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$currentDistrictId&date=$dateString';
    // print(_url);
    return await http
        .get(Uri.parse(_url))
        .then((value) => CenterList.fromJson(value.body));
  }
}