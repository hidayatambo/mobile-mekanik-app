import 'package:get/get.dart';

import '../controllers/detailhistory_controller.dart';

class DetailhistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailhistoryController>(
      () => DetailhistoryController(),
    );
  }
}
