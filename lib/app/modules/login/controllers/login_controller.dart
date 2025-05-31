import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class LoginController extends GetxController {
  final userType = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  
  final AuthService _authService = Get.find<AuthService>();
  
  void setUserType(String? value) {
    if (value != null) {
      userType.value = value;
    }
  }

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  Future<void> login() async {
    if (userType.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      final success = await _authService.login(
        email.value,
        password.value,
        userType.value,
      );

      if (success) {
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          'Erreur',
          'Identifiants invalides',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors de la connexion',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 