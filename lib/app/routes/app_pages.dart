import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

// Import pour la page de connexion
import '../modules/login/views/login_view.dart';
// Si tu as un binding pour la connexion, importe-le ici aussi
// import '../modules/login/bindings/login_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // Changer la route initiale pour pointer vers la page de connexion
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    // Définir la route pour la page de connexion
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      // Si tu as un binding pour la connexion, ajoute-le ici
      // binding: LoginBinding(),
    ),
  ];
}
