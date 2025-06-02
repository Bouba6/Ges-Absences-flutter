import 'package:get/get.dart';

class MainController extends GetxController {
  // Index de l'onglet actuellement sélectionné
  var selectedIndex = 1.obs; // Commence par "Accueil" si 1 correspond à Home

  // Changer d'onglet
  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
