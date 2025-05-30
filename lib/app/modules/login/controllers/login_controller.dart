import 'package:get/get.dart';

class LoginController extends GetxController {
  final userType = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  
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

  void login() {
    if (userType.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // TODO: Implémenter la logique de connexion
    Get.offAllNamed('/home');
  }
} 