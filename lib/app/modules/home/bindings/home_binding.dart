import 'package:gesabscences/app/Repositories/AuthRepositories.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../../Repositories/EleveRepositories.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(repository: EleveRepository()),
    );
    Get.lazyPut<AuthService>(() => AuthService());
  }
}
