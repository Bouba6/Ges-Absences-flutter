import 'package:flutter/material.dart';
import 'package:gesabscences/app/Repositories/AuthRepositories.dart';
import 'package:gesabscences/app/modules/Abscence/views/abscence_view.dart';
import 'package:gesabscences/app/modules/Pointage/views/pointage_view.dart';
import 'package:gesabscences/app/modules/cours/views/cours_view.dart';
import 'package:gesabscences/app/modules/home/views/home_view.dart';
import 'package:gesabscences/app/modules/route/views/route_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

class PermissionService extends GetxService {
  final AuthService _authService = Get.find();

  String? get userRole => _authService.getUserRole();
  bool get isVigile => userRole == 'VIGILE';
  bool get isAdmin => userRole == 'ADMIN';
  bool get isStudent => userRole == 'STUDENT';

  // ✅ Permissions pour différentes fonctionnalités
  bool canAccessPointage() => !isStudent; // Tous les rôles
  bool canAccessAbsence() => !isVigile; // Pas les vigiles
  bool canAccessStudents() => !isStudent; // Tous les rôles
  bool canManageUsers() => isAdmin; // Seulement admin
  bool canViewReports() => !isVigile; // Pas les vigiles
  bool canViewRoutes() => !isVigile; // Pas les vigiles
  bool canSeeCours() => !isVigile;

  // ✅ Configuration des menus basée sur les permissions
  List<NavigationItem> getAuthorizedMenus() {
    List<NavigationItem> menus = [];

    if (canAccessPointage()) {
      menus.add(
        NavigationItem(
          index: menus.length,
          title: 'Pointage',
          icon: Icons.login,
          page: const PointageView(),
        ),
      );
    }

    if(canSeeCours()){
      menus.add(
        NavigationItem(index: menus.length, title: 'Cours', icon: Icons.book, page: const CoursView()),
      );
    }

    if (canAccessAbsence()) {
      menus.add(
        NavigationItem(
          index: menus.length,
          title: 'Absence',
          icon: Icons.home_filled,
          page: const AbsenceView(),
        ),
      );
    }

    if (canAccessStudents()) {
      menus.add(
        NavigationItem(
          index: menus.length,
          title: 'Étudiants',
          icon: Icons.list_alt_sharp,
          page: HomeView(),
        ),
      );
    }

    if (canViewRoutes()) {
      menus.add(
        NavigationItem(
          index: menus.length,
          title: 'Itinéraires',
          icon: Icons.directions,
          page: const RouteView(),
        ),
      );
    }

    return menus;
  }
}

class NavigationItem {
  final int index;
  final String title;
  final IconData icon;
  final Widget page;

  NavigationItem({
    required this.index,
    required this.title,
    required this.icon,
    required this.page,
  });
}
