import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gesabscences/app/Repositories/AuthRepositories.dart';
import 'package:gesabscences/app/Repositories/EleveRepositories.dart';
import 'package:gesabscences/app/data/dto/Request/AbscenceRequest.dart';
import 'package:gesabscences/app/data/dto/Response/AbscenceResponse.dart';
import 'package:gesabscences/app/data/dto/Response/Eleveesponse.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

class AbsenceRepository {
  static const String baseUrl =
      'https://ges-abscences-backend.onrender.com/api/v1/mobile';

  static final Dio _dio = Dio(); // Dio peut être partagé ou injecté aussi
  static final AuthService _authService = Get.find<AuthService>();
  final EleveRepository _eleveRepository = Get.put<EleveRepository>(
    EleveRepository(),
  );

  // Récupérer les absences d'un élève
  Future<List<Abscenceresponse>> getAbsencesByEleveId(String eleveId) async {
    try {
      final String? userId = _authService.getUserId();
      EleveResponse eleveResponse = await _eleveRepository.getEleveByUserId(
        userId ?? '',
      );
      eleveId = eleveResponse.id;
      if (eleveId == null) {
        throw Exception(
          "ID utilisateur non trouvé. L'utilisateur n'est peut-être pas connecté.",
        );
      }
      // String eleveId = "683d74bd827bef35f1e7261a";
      final url = Uri.parse('$baseUrl/abscences/eleve/$eleveId');

      print('GET absences pour élève: $eleveId');
      print('URL: $url');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Gérer la structure de réponse (supposant une structure similaire aux pointages)
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('results')) {
          final List<dynamic> jsonData = responseData['results'];
          print('Nombre d\'absences trouvées: ${jsonData.length}');
          return jsonData
              .map((json) => Abscenceresponse.fromJson(json))
              .toList();
        } else if (responseData is List) {
          print('Nombre d\'absences trouvées: ${responseData.length}');
          return responseData
              .map((json) => Abscenceresponse.fromJson(json))
              .toList();
        } else {
          print('Structure de réponse inattendue: $responseData');
          return [];
        }
      } else {
        print('Erreur HTTP: ${response.statusCode} - ${response.body}');
        throw Exception(
          'Erreur lors de la récupération des absences: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erreur dans getAbsencesByEleveId: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Mettre à jour une absence
  static Future<bool> updateAbsence(
    String absenceId,
    UpdateAbsenceRequest request,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/abscences/update/$absenceId');

      print('PUT absence: $absenceId');
      print('URL: $url');
      print('Request Body: ${json.encode(request.toJson())}');

      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Absence mise à jour avec succès');
        return true;
      } else {
        print(
          '❌ Erreur lors de la mise à jour: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Erreur lors de la mise à jour: ${response.body}');
      }
    } catch (e) {
      print('Erreur dans updateAbsence: $e');
      throw Exception('Erreur lors de la mise à jour: $e');
    }
  }

  // Méthode utilitaire pour justifier une absence
  static Future<bool> justifierAbsence(
    String absenceId,
    Abscenceresponse absence,
    String justificatifId,
  ) async {
    final request = UpdateAbsenceRequest(
      statutAbscence: 'JUSTIFIER',
      eleveId: absence.eleveId,
      justificatifId: justificatifId,
      coursId: absence.coursId,
      typeAbscence: absence.statutAbscence,
    );

    return await updateAbsence(absenceId, request);
  }

  // Méthode utilitaire pour marquer comme non justifiée
  static Future<bool> marquerNonJustifiee(
    String absenceId,
    Abscenceresponse absence,
  ) async {
    final request = UpdateAbsenceRequest(
      statutAbscence: 'JUSTIFIER',
      eleveId: absence.eleveId,
      justificatifId: null, // Retirer le justificatif
      coursId: absence.coursId,
      typeAbscence: absence.statutAbscence,
    );

    return await updateAbsence(absenceId, request);
  }

  // À ajouter dans votre AbsenceRepository
  // Dans votre AbsenceRepository.dart, modifiez la méthode creerJustificatif

  static Future<bool> creerJustificatif({
    required String justificatif,
    required String statutJustification,
    required String abscenceId,
    List<String>? imageUrl,
  }) async {
    try {
      // https://ges-abscences-backend.onrender.com
      const String baseUrl = 'https://ges-abscences-backend.onrender.com';
      final Uri url = Uri.parse('$baseUrl/api/v1/mobile/justifier');

      // ✅ Validation des paramètres avant l'envoi
      print('\n🔍 === VALIDATION PARAMÈTRES ===');
      print(
        '📝 justificatif: "$justificatif" (length: ${justificatif.length})',
      );
      print('📊 statutJustification: "$statutJustification"');
      print('🆔 abscenceId: "$abscenceId" (length: ${abscenceId.length})');
      print('🖼️ imageUrl count: ${imageUrl?.length ?? 0}');

      // Validation des champs requis
      if (justificatif.trim().isEmpty) {
        print('❌ ERROR: justificatif est vide');
        return false;
      }

      if (abscenceId.trim().isEmpty) {
        print('❌ ERROR: abscenceId est vide');
        return false;
      }

      // Vérifier le format de l'abscenceId (MongoDB ObjectId = 24 caractères hex)
      if (abscenceId.length != 24 ||
          !RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(abscenceId)) {
        print('⚠️ WARNING: abscenceId format suspect: $abscenceId');
      }

      // ✅ Créer le body avec validation
      final Map<String, dynamic> requestBody = {
        'justificatif': justificatif.trim(),
        'statutJustification': statutJustification,
        'abscenceId': abscenceId.trim(),
      };

      // ✅ Validation et ajout des URLs d'images
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Valider chaque URL
        final validUrls = <String>[];
        for (int i = 0; i < imageUrl.length; i++) {
          final url = imageUrl[i].trim();
          if (url.isNotEmpty && Uri.tryParse(url) != null) {
            validUrls.add(url);
            print('✅ Image $i URL valide: $url');
          } else {
            print('❌ Image $i URL invalide: $url');
          }
        }

        if (validUrls.isNotEmpty) {
          requestBody['imageUrl'] = validUrls;
        }
      }

      // 🐛 DEBUG COMPLET
      print('\n🚀 === REQUÊTE API ===');
      print('🔗 URL: $url');
      print('📝 Body JSON:');
      final jsonBody = jsonEncode(requestBody);
      print(jsonBody);
      print('📊 Body size: ${jsonBody.length} bytes');

      // ✅ Headers plus complets
      final headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        'User-Agent': 'Flutter-App/1.0',
      };

      print('📋 Headers: $headers');

      final response = await http.post(url, headers: headers, body: jsonBody);

      // 🐛 DEBUG RÉPONSE COMPLÈTE
      print('\n📡 === RÉPONSE SERVEUR ===');
      print('📊 Status Code: ${response.statusCode}');
      print('📋 Response Headers: ${response.headers}');
      print('📄 Response Body: ${response.body}');
      print('📏 Response Body Length: ${response.body.length}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Justificatif créé avec succès!');

        try {
          final responseData = jsonDecode(response.body);
          print('📋 Données réponse: $responseData');
        } catch (e) {
          print('⚠️ Réponse non-JSON (mais succès): ${response.body}');
        }

        return true;
      } else {
        print('❌ ÉCHEC - Status: ${response.statusCode}');

        // ✅ Analyse détaillée des erreurs courantes
        switch (response.statusCode) {
          case 400:
            print('🔍 Bad Request - Possible causes:');
            print('  • Champ requis manquant');
            print('  • Format de données incorrect');
            print('  • abscenceId invalide');
            print('  • imageUrl format incorrect');
            break;
          case 401:
            print('🔍 Unauthorized - Token d\'authentification requis?');
            break;
          case 404:
            print('🔍 Not Found - Endpoint ou ressource introuvable');
            break;
          case 422:
            print('🔍 Unprocessable Entity - Erreur de validation');
            break;
          case 500:
            print('🔍 Internal Server Error - Problème côté serveur');
            break;
        }

        // ✅ Essayer de décoder l'erreur
        try {
          final errorData = jsonDecode(response.body);
          print('🔍 Détails erreur JSON: $errorData');

          // Afficher les détails spécifiques si disponibles
          if (errorData is Map<String, dynamic>) {
            if (errorData.containsKey('message')) {
              print('💬 Message: ${errorData['message']}');
            }
            if (errorData.containsKey('errors')) {
              print('📝 Erreurs détaillées: ${errorData['errors']}');
            }
            if (errorData.containsKey('details')) {
              print('🔎 Détails: ${errorData['details']}');
            }
          }
        } catch (e) {
          print('⚠️ Réponse d\'erreur non-JSON: ${response.body}');
        }

        return false;
      }
    } catch (e, stackTrace) {
      print('\n💥 === EXCEPTION ===');
      print('❌ Exception: $e');
      print('📍 Type: ${e.runtimeType}');

      // ✅ Analyse des exceptions courantes
      if (e is SocketException) {
        print('🌐 Problème de connexion réseau');
      } else if (e is TimeoutException) {
        print('⏱️ Timeout de la requête');
      } else if (e is FormatException) {
        print('📄 Erreur de format JSON');
      }

      print('🔍 Stack trace: $stackTrace');
      return false;
    }
  }
}
