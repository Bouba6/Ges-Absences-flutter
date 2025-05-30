import 'package:get/get.dart';
import '../data/dto/Response/Eleveesponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EleveRepository extends GetConnect {
  static const _baseUrl = 'http://192.168.1.8:8080/api/v1/mobile/eleves';

  Future<List<EleveResponse>> fetchEleves() async {
    final response = await get(_baseUrl);
    print("Status code: ${response.statusCode}");
    if (response.isOk) {
      print("Status code: ${response.statusCode}");
      return (response.body['results'] as List)
          .map((json) => EleveResponse.fromJson(json))
          .toList();
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }

  Future<EleveResponse> fetchEleveById(String id) async {
    final response = await get('$_baseUrl/$id');
    print("Requête vers $_baseUrl/$id");
    print("Status code: ${response.statusCode}");
    print("Body: ${response.body}");
    if (response.isOk) {
      // Tu dois extraire l'objet Eleve à l'intérieur du champ "results"
      return EleveResponse.fromJson(response.body['results']);
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }

  Future<EleveResponse> createEleve(EleveResponse eleve) async {
    final response = await post(_baseUrl, eleve.toJson());
    if (response.isOk) {
      return EleveResponse.fromJson(response.body);
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }

  Future<void> validerPresence(String eleveId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pointage/valider-presence'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'eleveId': eleveId,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Erreur lors de la validation');
      }
    } catch (e) {
      throw Exception('Erreur de validation: $e');
    }
  }

  // Ajoute update, delete selon besoin
}
