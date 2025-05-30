import 'package:get/get.dart';
import '../../../data/models/etudiant.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {

  final count = 0.obs;

  var historiquePointage = <Map<String, String>>[].obs;

  final List<Etudiant> _etudiants = mockEtudiants;

  final TextEditingController studentIdController = TextEditingController();

  @override
  void onClose() {
    studentIdController.dispose();
    super.onClose();
  }

  Etudiant? findEtudiantByMatricule(String matricule) {
    return _etudiants.firstWhereOrNull((etudiant) => etudiant.matricule == matricule);
  }

  void addPointage(Etudiant etudiant) {
    final now = TimeOfDay.now();
    final formattedTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final pointage = {
      'nom': '${etudiant.prenom} ${etudiant.nom}',
      'heure': formattedTime,
    };

    historiquePointage.insert(0, pointage);

    if (historiquePointage.length > 4) {
      historiquePointage.removeLast();
    }
  }

  void increment() => count.value++;

  void clearStudentIdField() {
    studentIdController.clear();
  }

  void seDeconnecter() {
    print('Simulating logout...');
    historiquePointage.clear();
    Get.snackbar('Déconnexion', 'Vous êtes déconnecté.', snackPosition: SnackPosition.BOTTOM);
  }
}
