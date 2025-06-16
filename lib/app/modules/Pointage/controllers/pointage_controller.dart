import 'package:gesabscences/app/Repositories/PointageRepositories.dart';
import 'package:get/get.dart';
import 'package:gesabscences/app/core/Enums/pointageState.dart';
import 'package:gesabscences/app/data/dto/Response/PointageResponse.dart';
// Import votre repository

class PointageController extends GetxController {
  var state = PointageState.loading.obs;
  var pointages = <PointageResponse>[].obs;
  var errorMessage = ''.obs;
  final Pointagerepositories _pointagerepositories = Pointagerepositories();

  @override
  void onInit() {
    super.onInit();
    loadPointages();
  }

  Future<void> loadPointages() async {
    try {
      state.value = PointageState.loading;

      // ID hardcodé directement dans le repository
      print('Chargement des pointages...'); // Debug

      final result = await _pointagerepositories.getPointagesByVigileId();

      print('Résultat reçu: $result'); // Debug
      print('Nombre d\'éléments: ${result.length}'); // Debug

      pointages.value = result;

      if (pointages.isEmpty) {
        state.value = PointageState.empty;
        print('Aucun pointage trouvé'); // Debug
      } else {
        state.value = PointageState.loaded;
        print('${pointages.length} pointages chargés'); // Debug
      }
    } catch (e) {
      print('Erreur dans loadPointages: $e'); // Debug
      state.value = PointageState.error;
      errorMessage.value = 'Erreur lors du chargement des pointages: $e';
    }
  }

  Future<void> refresh() async {
    await loadPointages();
  }
}
