import 'package:get/get.dart';

import '../modules/Abscence/bindings/abscence_binding.dart';
import '../modules/Abscence/views/abscence_view.dart';
import '../modules/Main/bindings/main_binding.dart';
import '../modules/Main/views/main_view.dart';
import '../modules/Pointage/bindings/pointage_binding.dart';
import '../modules/Pointage/views/pointage_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
  ];
}
