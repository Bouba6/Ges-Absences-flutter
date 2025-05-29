import 'package:get/get.dart';
import '../modules/gestion_absences/views/absence_list_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ABSENCES;

  static final routes = [
    GetPage(
      name: _Paths.ABSENCES,
      page: () => AbsenceListView(),
    ),
  ];
}
