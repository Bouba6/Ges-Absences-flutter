// controllers/absence_controller.dart
import 'package:gesabscences/app/Repositories/AbscenceRepository.dart';
import 'package:gesabscences/app/core/Enums/AbscenceState.dart';
import 'package:gesabscences/app/data/dto/Response/AbscenceResponse.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AbscenceController extends GetxController {
  var state = AbsenceState.loading.obs;
  var absences = <Abscenceresponse>[].obs;
  var errorMessage = ''.obs;
  var eleveId = '683997d214d219133e657125'.obs;
  var isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAbsences();
  }

  // Version corrigée avec timeout et meilleur debug
  Future<void> loadAbsences({String? specificEleveId}) async {
    try {
      state.value = AbsenceState.loading;
      errorMessage.value = '';

      final targetEleveId = specificEleveId ?? eleveId.value;
      if (targetEleveId.isEmpty) {
        throw Exception('ID élève manquant');
      }

      print('🔄 Début chargement absences pour élève: $targetEleveId');

      // Ajouter un timeout pour éviter les blocages infinis
      final result = await AbsenceRepository.getAbsencesByEleveId(
        targetEleveId,
      ).timeout(
        Duration(seconds: 30), // Timeout de 30 secondes
        onTimeout: () {
          print('⏰ Timeout atteint lors du chargement des absences');
          throw Exception(
            'Délai d\'attente dépassé. Vérifiez votre connexion.',
          );
        },
      );

      print('✅ Réponse reçue: ${result?.length ?? 0} absences');

      if (result == null) {
        throw Exception('Réponse nulle du serveur');
      }

      absences.value = result;

      if (absences.isEmpty) {
        state.value = AbsenceState.empty;
        print('📭 Aucune absence trouvée');
      } else {
        state.value = AbsenceState.loaded;
        print('📋 ${absences.length} absences chargées avec succès');
      }
    } catch (e) {
      print('❌ Erreur dans loadAbsences: $e');
      print('📍 Type d\'erreur: ${e.runtimeType}');
      state.value = AbsenceState.error;
      errorMessage.value = 'Erreur lors du chargement: $e';
    }
  }

  Future<void> refresh() async {
    await loadAbsences();
  }

  // Test simple pour vérifier la connexion
  Future<void> testConnection() async {
    try {
      print('🧪 Test de connexion...');
      state.value = AbsenceState.loading;

      // Test direct avec votre URL
      final targetEleveId = eleveId.value;
      print('🔗 Test avec eleveId: $targetEleveId');

      final result = await AbsenceRepository.getAbsencesByEleveId(
        targetEleveId,
      );
      print('🎯 Résultat test: $result');

      if (result != null) {
        absences.value = result;
        state.value = result.isEmpty ? AbsenceState.empty : AbsenceState.loaded;
        print('✅ Test réussi: ${result.length} absences');
      } else {
        state.value = AbsenceState.error;
        errorMessage.value = 'Réponse nulle du serveur';
      }
    } catch (e) {
      print('❌ Échec du test: $e');
      state.value = AbsenceState.error;
      errorMessage.value = 'Test échoué: $e';
    }
  }

  Future<void> justifierAbsence(Abscenceresponse absence) async {
    try {
      final justificatifText = await _showJustificatifDialog();

      if (justificatifText == null || justificatifText.isEmpty) {
        Get.snackbar(
          'Annulé',
          'Justification annulée',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      isUpdating.value = true;

      // Créer le justificatif via l'endpoint POST avec statutJustification = "EN_ATTENTE"
      final success = await AbsenceRepository.creerJustificatif(
        justificatifText,
        "EN_ATTENTE",
        absence.id,
      ).timeout(Duration(seconds: 15));

      if (success) {
        Get.snackbar(
          'Succès',
          'Justificatif créé avec succès (en attente de validation)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await refresh();
      }
    } catch (e) {
      print('Erreur lors de la création du justificatif: $e');
      Get.snackbar(
        'Erreur',
        'Erreur lors de la création du justificatif: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> marquerNonJustifiee(Abscenceresponse absence) async {
    try {
      final confirmed = await _showConfirmationDialog(
        'Confirmer',
        'Marquer cette absence comme non justifiée ?',
      );

      if (!confirmed) return;

      isUpdating.value = true;

      final success = await AbsenceRepository.marquerNonJustifiee(
        absence.id,
        absence,
      ).timeout(Duration(seconds: 15));

      if (success) {
        Get.snackbar(
          'Succès',
          'Absence marquée comme non justifiée',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        await refresh();
      }
    } catch (e) {
      print('Erreur lors du marquage: $e');
      Get.snackbar(
        'Erreur',
        'Erreur lors du marquage: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<String?> _showJustificatifDialog() async {
    final textController = TextEditingController();

    return await Get.dialog<String>(
      AlertDialog(
        title: const Text('Justifier l\'absence'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Saisissez votre justificatif :'),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Justificatif',
                border: OutlineInputBorder(),
                hintText: 'Ex: Maladie, rendez-vous médical...',
              ),
              maxLines: 3,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = textController.text.trim();
              Get.back(result: value.isNotEmpty ? value : null);
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog(String title, String message) async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Confirmer'),
              ),
            ],
          ),
        ) ??
        false;
  }
}