import 'package:get/get.dart';
import '../../../Repositories/EleveRepositories.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Injection du repository
    Get.lazyPut<EleveRepository>(() => EleveRepository());

    // Injection du controller avec le repository injecté
    Get.lazyPut<HomeController>(
      () => HomeController(repository: Get.find<EleveRepository>()),
    );
  }
}
