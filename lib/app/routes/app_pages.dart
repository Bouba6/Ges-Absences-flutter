import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

// Import pour la page de connexion
import '../modules/login/views/login_view.dart';
import '../modules/login/bindings/login_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // Changer la route initiale pour pointer vers la page de connexion
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    // Définir la route pour la page de connexion
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
