import 'dart:convert';
import 'package:gesabscences/app/data/dto/Request/AbscenceRequest.dart';
import 'package:gesabscences/app/data/dto/Response/AbscenceResponse.dart';
import 'package:http/http.dart' as http;

class AbsenceRepository {
  static const String baseUrl = 'http://192.168.1.8:8080/api/v1/mobile';

  // Récupérer les absences d'un élève
  static Future<List<Abscenceresponse>> getAbsencesByEleveId(
    String eleveId,
  ) async {
    try {
      String eleveId = "683997d214d219133e657125";
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
  static Future<bool> creerJustificatif(
    String justificatif,
    String statutJustification,
    String abscenceId,
  ) async {
    try {
      final url = 'http://192.168.1.8:8080/api/v1/mobile/justifier';

      final body = {
        'justificatif': justificatif,
        'statutJustification': statutJustification,
        'abscenceId': abscenceId,
      };

      print('🚀 Envoi justificatif vers: $url');
      print('📋 Données: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('📬 Statut réponse: ${response.statusCode}');
      print('📄 Réponse: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Justificatif créé avec succès');
        return true;
      } else {
        print('❌ Erreur HTTP: ${response.statusCode}');
        print('📄 Corps de la réponse: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de la création du justificatif: $e');
      return false;
    }
  }
}
