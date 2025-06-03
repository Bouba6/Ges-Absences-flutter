// controllers/absence_controller.dart
import 'dart:io';

import 'package:gesabscences/app/Repositories/AbscenceRepository.dart';
import 'package:gesabscences/app/Repositories/StorageRepository.dart';
import 'package:gesabscences/app/core/Enums/AbscenceState.dart';
import 'package:gesabscences/app/data/dto/Response/AbscenceResponse.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AbscenceController extends GetxController {
  final AbsenceRepository _absenceRepository = AbsenceRepository();
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
      final result = await _absenceRepository
          .getAbsencesByEleveId(targetEleveId)
          .timeout(
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

      final result = await _absenceRepository.getAbsencesByEleveId(
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
      final justificatifResult = await _showJustificatifDialog();

      if (justificatifResult == null ||
          (justificatifResult['justificatif'] as String).isEmpty) {
        Get.snackbar(
          'Annulé',
          'Justification annulée',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      isUpdating.value = true;
      final justificatifText = justificatifResult['justificatif'] as String;
      final imageUrl = justificatifResult['imageUrl'] as String?;
      // Créer le justificatif via l'endpoint POST avec statutJustification = "EN_ATTENTE"
      final success = await AbsenceRepository.creerJustificatif(
        justificatif: justificatifText,
        statutJustification: "EN_ATTENTE",
        abscenceId: absence.id,
        imageUrl: imageUrl,
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

  Future<Map<String, dynamic>?> _showJustificatifDialog() async {
  final textController = TextEditingController();
  File? selectedImage;
  String? imageUrl;
  final storageService = StorageService();

  return await Get.dialog<Map<String, dynamic>?>(
    StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Justifier l\'absence'),
          content: SingleChildScrollView(
            child: Column(
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
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        selectedImage = File(pickedFile.path);
                      });
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Choisir une image"),
                ),
                if (selectedImage != null) ...[
                  const SizedBox(height: 8),
                  Image.file(selectedImage!, height: 100),
                  const SizedBox(height: 8),
                  Text(
                    'Image sélectionnée: ${selectedImage!.path.split('/').last}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: null),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final text = textController.text.trim();
                if (text.isEmpty) {
                  Get.snackbar('Erreur', 'Le justificatif est vide.');
                  return;
                }

                try {
                  // Upload image s'il y en a une - PASSEZ L'IMAGE EN PARAMÈTRE
                  if (selectedImage != null) {
                    // Afficher un indicateur de chargement
                    Get.dialog(
                      const AlertDialog(
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 16),
                            Text('Upload en cours...'),
                          ],
                        ),
                      ),
                      barrierDismissible: false,
                    );

                    // Appeler la méthode avec l'image en paramètre
                    imageUrl = await storageService.uploadImageAndGetUrl(selectedImage!);
                    
                    // Fermer l'indicateur de chargement
                    Get.back();
                  }

                  // Retourner le résultat et fermer le dialog
                  Get.back(
                    result: {'justificatif': text, 'imageUrl': imageUrl},
                  );
                } catch (e) {
                  // Fermer l'indicateur de chargement si il y a une erreur
                  if (Get.isDialogOpen == true) {
                    Get.back();
                  }
                  
                  Get.snackbar(
                    'Erreur', 
                    'Erreur lors de l\'upload: ${e.toString()}',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    ),
  );
}

  Future<bool> _showConfirmationDialog(String title, String message) async {
    return await Get.dialog(
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
