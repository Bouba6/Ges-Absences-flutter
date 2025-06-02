import 'package:get/get.dart';
import '../data/dto/Response/Eleveesponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EleveRepository extends GetConnect {
  static const _baseUrl = 'https://ges-abscences-backend.onrender.com/api/v1/mobile';

  Future<List<EleveResponse>> fetchEleves() async {
    final response = await http.get(Uri.parse('$_baseUrl/eleves'));

    print("Status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['results'] is List) {
        return (data['results'] as List)
            .map((json) => EleveResponse.fromJson(json))
            .toList();
      } else {
        throw Exception("Format de données inattendu");
      }
    } else {
      throw Exception('Erreur HTTP ${response.statusCode}');
    }
  }

  Future<EleveResponse> fetchEleveById(String id) async {
    final response = await get('$_baseUrl/eleves/$id');
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

  Future<void> validerPresence(String eleveId, String idVigile) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/pointage/valider-presence'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'eleveId': eleveId,
          'heureArrivee': "2025-05-30T07:00:00.000Z",
          'idVigile': idVigile,
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

  Future<EleveResponse> getEleveByUserId(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/eleves/user/$userId'));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data =
          jsonBody['results']; // <- Ici on extrait directement "results"

      print("Status code: ${response.statusCode}");
      print(EleveResponse.fromJson(data));
      return EleveResponse.fromJson(data);
    } else {
      throw Exception('Élève non trouvé pour userId: $userId');
    }
  }

  // Ajoute update, delete selon besoin
}
