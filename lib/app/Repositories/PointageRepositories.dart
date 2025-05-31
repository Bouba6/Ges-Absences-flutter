import 'package:gesabscences/app/data/dto/Response/PointageResponse.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Pointagerepositories {
  static const baseUrl = 'http://192.168.1.8:8080/api/v1/mobile';

  static Future<List<PointageResponse>> getPointagesByVigileId(
  ) async {
    try {
      final url = Uri.parse(
        '$baseUrl/pointage/byVigileId/6839861414d219133e656d7e',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Ajoutez ici vos headers d'authentification si nécessaire
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Vérifiez la structure de votre réponse JSON
        // D'après vos données, il semble que vous ayez une structure avec "results"
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('results')) {
          final List<dynamic> jsonData = responseData['results'];
          print('Nombre de pointages trouvés: ${jsonData.length}'); // Debug
          return jsonData
              .map((json) => PointageResponse.fromJson(json))
              .toList();
        }
        // Si c'est directement une liste
        else if (responseData is List) {
          print('Nombre de pointages trouvés: ${responseData.length}'); // Debug
          return responseData
              .map((json) => PointageResponse.fromJson(json))
              .toList();
        } else {
          print('Structure de réponse inattendue: $responseData');
          return [];
        }
      } else {
        print('Erreur HTTP: ${response.statusCode} - ${response.body}');
        throw Exception(
          'Erreur lors de la récupération des pointages: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}
