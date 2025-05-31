import 'package:get/get.dart';

class HomeController extends GetxController {
  final EleveRepository repository;

  HomeController({required this.repository});

  var eleves = <EleveResponse>[].obs;
  var loading = true.obs;
  var error = ''.obs;
  var selectedEleve = Rxn<EleveResponse>();
  var loadingEleve = false.obs;
  var validatingPresence = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadEleves();
  }

  Future<void> loadEleves() async {
    try {
      loading.value = true;
      eleves.value = await repository.fetchEleves();
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  void findEleveById(String id) async {
    try {
      loadingEleve.value = true;
      selectedEleve.value = await repository.fetchEleveById(id);
    } catch (e) {
      selectedEleve.value = null;
      Get.snackbar('Erreur', 'Aucun élève trouvé avec cet ID');
    } finally {
      loadingEleve.value = false;
    }
  }

  Future<void> validerPresence(String eleveId) async {
    try {
      validatingPresence.value = true;

      // Appel à l'endpoint de validation
      await repository.validerPresence(eleveId);

      // Mettre à jour la liste des élèves après validation
      await loadEleves();

      Get.snackbar(
        'Succès',
        'Présence validée avec succès',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la validation: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      validatingPresence.value = false;
    }
  }

  void openScanner() async {
    try {
      // Rediriger vers la page de scan
      final result = await Get.toNamed('/scanner');

      // Si un ID est scanné, rechercher l'élève
      if (result != null && result is String && result.isNotEmpty) {
        findEleveById(result);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de l\'ouverture du scanner');
    }
  }
}
