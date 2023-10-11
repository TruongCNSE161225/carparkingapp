import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<bool> visionPrice = true.obs;

  void init() {}

  void deposit(){
    Get.toNamed('/deposit');
  }
}
