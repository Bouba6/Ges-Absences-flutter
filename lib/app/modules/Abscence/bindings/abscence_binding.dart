import 'package:get/get.dart';

import '../controllers/abscence_controller.dart';

class AbscenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbscenceController>(
      () => AbscenceController(),
    );
  }
}
