import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Couleurs principales
    const Color backgroundColor = Colors.white;
    const Color sideColor = Color(0xFF232323); // Couleur des marges
    const Color buttonColor = Color(0xFFA86A1D); // Marron/orangé du bouton
    const Color borderColor = Color(0xFFBDBDBD); // Gris clair pour les bordures

    return Scaffold(
      backgroundColor: sideColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Image.asset(
                    'assets/logoism.png',
                    height: 120,
                  ),
                ),
                // Dropdown type d'utilisateur
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    alignment: AlignmentDirectional.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Vigile / Etudiant',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Vigile',
                        child: Text(
                          'Vigile',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Etudiant',
                        child: Text(
                          'Etudiant',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    onChanged: controller.setUserType,
                  ),
                ),
                // Champ email
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                    onChanged: controller.setEmail,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: borderColor),
                      ),
                    ),
                  ),
                ),
                // Champ mot de passe
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    onChanged: controller.setPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Mots de passe',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: borderColor),
                      ),
                    ),
                  ),
                ),
                // Lien mot de passe oublié
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Mots de passe oublié?',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                // Bouton connexion
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Connexion',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 