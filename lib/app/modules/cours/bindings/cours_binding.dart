import 'package:get/get.dart';

import '../controllers/cours_controller.dart';

class CoursBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoursController>(
      () => CoursController(),
    );
  }
}
