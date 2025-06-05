import 'package:get/get.dart';

import '../controllers/route_controller.dart';

class RouteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RouteController>(
      () => RouteController(),
    );
  }
}
