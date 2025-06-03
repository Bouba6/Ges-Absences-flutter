import 'package:gesabscences/app/Repositories/EleveRepositories.dart';
import 'package:gesabscences/app/modules/Abscence/controllers/abscence_controller.dart';
import 'package:gesabscences/app/modules/Pointage/controllers/pointage_controller.dart';
import 'package:gesabscences/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(
      () => HomeController(repository: EleveRepository()),
    );
    Get.lazyPut<PointageController>(() => PointageController());

    Get.lazyPut<AbscenceController>(() => AbscenceController());
  }
}
