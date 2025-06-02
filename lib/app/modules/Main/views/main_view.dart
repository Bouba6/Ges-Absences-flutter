import 'package:flutter/material.dart';
import 'package:gesabscences/app/Repositories/AuthRepositories.dart';
import 'package:gesabscences/app/Repositories/PermissonRepository.dart';
import 'package:gesabscences/app/modules/Abscence/views/abscence_view.dart';
import 'package:gesabscences/app/modules/Pointage/views/pointage_view.dart';
import 'package:gesabscences/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import 'greetingapp.dart';
import 'navBar.dart';
import '../../home/views/home_view.dart';

class MainView extends GetView<MainController> {
  MainView({super.key});

  final AuthService _authService = Get.find<AuthService>();

  final PermissionService _permissionService = Get.put(PermissionService());

  void _logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.LOGIN);
    Get.snackbar(
      'Déconnexion',
      'Vous avez été déconnecté avec succès',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authorizedMenus = _permissionService.getAuthorizedMenus();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF351F16), // Marron foncé ISM
          foregroundColor: const Color(
            0xFFFFFFFF,
          ), // Blanc pour les textes/icônes
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF351F16), // Marron foncé
                  Color(0xFF4A2B1F), // Marron légèrement plus clair
                ],
              ),
            ),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFF58613).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              authorizedMenus[controller.selectedIndex.value.clamp(
                    0,
                    authorizedMenus.length - 1,
                  )]
                  .title,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            // Badge du rôle utilisateur
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFF58613), // Orange ISM
                      Color(0xFFFF9533), // Orange plus clair
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF58613).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: const Color(0xFFFFFFFF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _authService.getUserRole() ?? 'User',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bouton de déconnexion
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFFFFF).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFFFFFFF),
                  size: 22,
                ),
                onPressed: _logout,
                tooltip: 'Se déconnecter',
                splashColor: const Color(0xFFF58613).withOpacity(0.3),
                highlightColor: const Color(0xFFF58613).withOpacity(0.1),
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: controller.selectedIndex.value.clamp(
            0,
            authorizedMenus.length - 1,
          ),
          children: authorizedMenus.map((menu) => menu.page).toList(),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          icons: authorizedMenus.map((menu) => menu.icon).toList(),
          maxIndex: authorizedMenus.length - 1,
        ),
      ),
    );
  }
}
