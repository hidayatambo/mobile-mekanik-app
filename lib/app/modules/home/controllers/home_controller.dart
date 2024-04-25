import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/localstorage.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var isBookingApproved = false.obs;

  void setBookingApproved(bool value) {
    isBookingApproved.value = value;
  }
  final count = 0.obs;

  List<RefreshController> refreshControllers = [];

  // Metode untuk melakukan refresh
  void refresh() {
    // Lakukan refresh pada semua RefreshController
    for (var controller in refreshControllers) {
      controller.refreshCompleted();
    }
  }
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
