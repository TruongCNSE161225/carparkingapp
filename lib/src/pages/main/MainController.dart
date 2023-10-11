import 'package:carparkingapp/src/pages/bike/bike_controller.dart';
import 'package:carparkingapp/src/pages/bike/bike_page.dart';
import 'package:carparkingapp/src/pages/home/home_controller.dart';
import 'package:carparkingapp/src/pages/home/home_page.dart';
import 'package:carparkingapp/src/pages/profile/profile_controller.dart';
import 'package:carparkingapp/src/pages/profile/profile_page.dart';
import 'package:carparkingapp/src/pages/history/history_controller.dart';
import 'package:carparkingapp/src/pages/history/history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  late HomeController _homeController;
  late BikeController _bikeController;
  late HistoryController _historyController;
  late ProfileController _profileController;

  PageStorageBucket bucket = PageStorageBucket();
  var currentTab = 0.obs;

  final List<Widget> _screens = [
    const HomePage(),
    const BikePage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  Widget get currentScreen => _screens[currentTab.value];

  @override
  void onInit() {
    initController();
    super.onInit();
  }

  void initController() {
    Get.put(
      HomeController(),
      permanent: true,
    );
    _homeController = Get.find<HomeController>();
    _homeController.init();

    Get.put(
      BikeController(),
      permanent: true,
    );
    _bikeController = Get.find<BikeController>();
    _bikeController.init();

    Get.put(
      HistoryController(),
      permanent: true,
    );
    _historyController = Get.find<HistoryController>();
    _historyController.init();

    Get.put(
      ProfileController(),
      permanent: true,
    );
    _profileController = Get.find<ProfileController>();
    _profileController.init();
  }

  void changeTab(int index) {
    currentTab.value = index;
    switch (index) {
      case 0:
        _homeController.init();
        break;
      case 1:
        _bikeController.init();
        break;
      case 2:
        _historyController.init();
        break;
      case 3:
        _profileController.init();
        break;
    }
  }
}
