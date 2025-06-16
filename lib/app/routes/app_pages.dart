import 'package:get/get.dart';

import '../middlewares/auth_middleware.dart';
import '../modules/Abscence/bindings/abscence_binding.dart';
import '../modules/Abscence/views/abscence_view.dart';
import '../modules/Main/bindings/main_binding.dart';
import '../modules/Main/views/main_view.dart';
import '../modules/Pointage/bindings/pointage_binding.dart';
import '../modules/Pointage/views/pointage_view.dart';
import '../modules/cours/bindings/cours_binding.dart';
import '../modules/cours/views/cours_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/scanner_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/route/bindings/route_binding.dart';
import '../modules/route/views/route_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(name: _Paths.MAIN, page: () => MainView(), binding: MainBinding()),
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ABSCENCE,
      page: () => AbsenceView(),
      binding: AbscenceBinding(),
    ),
    GetPage(
      name: _Paths.POINTAGE,
      page: () => PointageView(),
      binding: PointageBinding(),
    ),
    GetPage(name: _Paths.SCANNER, page: () => ScannerView()),
    GetPage(
      name: _Paths.ROUTE,
      page: () => const RouteView(),
      binding: RouteBinding(),
    ),
    GetPage(
      name: _Paths.COURS,
      page: () => const CoursView(),
      binding: CoursBinding(),
    ),
  ];
}
