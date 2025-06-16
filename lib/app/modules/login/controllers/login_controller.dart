import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Repositories/AuthRepositories.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    // ✅ PAS de _checkAuthStatus() ici !
    // L'utilisateur doit manuellement se connecter
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    if (isLoading.value) return; // Éviter les appels multiples

    isLoading.value = true;

    try {
      final response = await _authService.login(
        loginController.text.trim(),
        passwordController.text,
      );

      if (response.token != null) {
        // ✅ Navigation simple et immédiate
        Get.offAllNamed(Routes.MAIN);

        // ✅ Snackbar après navigation (optionnel)
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.snackbar(
            'Succès',
            'Connexion réussie',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        });
      } else {
        Get.snackbar(
          'Erreur',
          response.message ?? 'Identifiants incorrects',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Méthode pour vider le cache (debug seulement)
  void clearAuthCache() {
    _authService.logout();
    Get.snackbar(
      'Debug',
      'Cache vidé - vous pouvez maintenant tester la connexion',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    loginController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void logout() {
    _authService.logout(); // Nettoie le token
    Get.offAllNamed(Routes.LOGIN); // Redirige vers login
  }
}
