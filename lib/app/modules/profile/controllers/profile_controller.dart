import 'package:get/get.dart';

import '../../../data/localstorage.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController

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

  void increment() => count.value++;
  void logout() async {await LocalStorages.deleteToken; Get.offAllNamed(Routes.SIGNIN);}
}
