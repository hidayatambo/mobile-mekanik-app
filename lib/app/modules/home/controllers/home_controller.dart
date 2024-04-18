import 'package:get/get.dart';

import '../../../data/localstorage.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  void logout() async {await LocalStorages.deleteToken; Get.offAllNamed(Routes.SIGNIN);}
  void increment() => count.value++;
}
