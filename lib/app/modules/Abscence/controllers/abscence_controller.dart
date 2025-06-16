// controllers/absence_controller.dart
import 'dart:io';

import 'package:gesabscences/app/Repositories/AbscenceRepository.dart';
import 'package:gesabscences/app/Repositories/StorageRepository.dart';
import 'package:gesabscences/app/Repositories/SupabaseRepositories.dart';
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
      final imageUrls =
          justificatifResult['imageUrls'] as List<String>?; // ✅ Peut être null

      print('🚀 Création justificatif:');
      print('📝 Texte: $justificatifText');
      print('🖼️ Images: ${imageUrls?.length ?? 0}');
      print('🆔 AbsenceId: ${absence.id}');

      // ✅ Utilisation du bon nom de paramètre
      final success = await AbsenceRepository.creerJustificatif(
        justificatif: justificatifText,
        statutJustification: "EN_ATTENTE",
        abscenceId: absence.id,
        imageUrl: imageUrls ?? [], // ✅ Nom correct + valeur par défaut
      ).timeout(Duration(seconds: 30));

      if (success) {
        Get.snackbar(
          'Succès',
          'Justificatif créé avec succès (en attente de validation)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await refresh();
      } else {
        Get.snackbar(
          'Erreur',
          'Échec de la création du justificatif',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Exception dans justifierAbsence: $e');
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

  // ✅ Dialog modifié pour gérer plusieurs images
  Future<Map<String, dynamic>?> _showJustificatifDialog() async {
    final textController = TextEditingController();
    List<File> selectedImages = [];
    List<String> uploadedImageUrls = []; // ✅ Renommé pour clarté
    final storageService = SupabaseStorageService();
    bool isUploading = false;

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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              isUploading
                                  ? null
                                  : () async {
                                    final picker = ImagePicker();
                                    final pickedFiles = await picker
                                        .pickMultiImage(
                                          maxWidth: 1024,
                                          maxHeight: 1024,
                                          imageQuality: 85,
                                        );
                                    if (pickedFiles.isNotEmpty) {
                                      setState(() {
                                        selectedImages =
                                            pickedFiles
                                                .map(
                                                  (xFile) => File(xFile.path),
                                                )
                                                .toList();
                                      });
                                    }
                                  },
                          icon: const Icon(Icons.photo_library),
                          label: Text(
                            "Galerie\n(${selectedImages.length})",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              isUploading
                                  ? null
                                  : () async {
                                    final picker = ImagePicker();
                                    final pickedFile = await picker.pickImage(
                                      source: ImageSource.camera,
                                      maxWidth: 1024,
                                      maxHeight: 1024,
                                      imageQuality: 85,
                                    );
                                    if (pickedFile != null) {
                                      setState(() {
                                        selectedImages.add(
                                          File(pickedFile.path),
                                        );
                                      });
                                    }
                                  },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text(
                            "Caméra",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (selectedImages.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Images sélectionnées (${selectedImages.length}):',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    selectedImages[index],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap:
                                        isUploading
                                            ? null
                                            : () {
                                              setState(() {
                                                selectedImages.removeAt(index);
                                              });
                                            },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  if (isUploading) ...[
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 8),
                        Text(
                          'Upload en cours (${uploadedImageUrls.length}/${selectedImages.length})...',
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isUploading ? null : () => Get.back(result: null),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed:
                    isUploading
                        ? null
                        : () async {
                          final text = textController.text.trim();
                          if (text.isEmpty) {
                            Get.snackbar(
                              'Erreur',
                              'Le justificatif ne peut pas être vide.',
                            );
                            return;
                          }

                          try {
                            setState(() {
                              isUploading = true;
                              uploadedImageUrls.clear();
                            });

                            // ✅ Upload des images une par une avec feedback
                            if (selectedImages.isNotEmpty) {
                              for (int i = 0; i < selectedImages.length; i++) {
                                try {
                                  print(
                                    '📤 Upload image ${i + 1}/${selectedImages.length}',
                                  );
                                  final url = await storageService
                                      .uploadImageAndGetUrl(selectedImages[i]);
                                  if (url != null && url.isNotEmpty) {
                                    uploadedImageUrls.add(url);
                                    print('✅ Image ${i + 1} uploadée: $url');
                                    setState(
                                      () {},
                                    ); // Mettre à jour le compteur
                                  } else {
                                    print('⚠️ URL vide pour image ${i + 1}');
                                  }
                                } catch (e) {
                                  print('❌ Erreur upload image ${i + 1}: $e');
                                  // Continue avec les autres images
                                }
                              }
                            }

                            print(
                              '📊 Upload terminé: ${uploadedImageUrls.length}/${selectedImages.length} images',
                            );

                            // ✅ Retourner les données même si aucune image n'a été uploadée
                            Get.back(
                              result: {
                                'justificatif': text,
                                'imageUrls':
                                    uploadedImageUrls, // Peut être vide
                              },
                            );
                          } catch (e) {
                            print('❌ Erreur générale upload: $e');
                            setState(() {
                              isUploading = false;
                            });

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
