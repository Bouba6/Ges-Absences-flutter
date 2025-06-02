import 'package:gesabscences/app/Repositories/AuthRepositories.dart';
import 'package:gesabscences/app/Repositories/VigileRepoistory.dart';
import 'package:gesabscences/app/Repositories/userDataRepository.dart';
import 'package:gesabscences/app/data/dto/Response/PointageResponse.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Pointagerepositories {
  static const baseUrl = 'https://ges-abscences-backend.onrender.com/api/v1/mobile';
  static final AuthService _authService = Get.find<AuthService>();
  final VigileRepository _vigileRepository = Get.put<VigileRepository>(
    VigileRepository(),
  );
  final UserDataService _userDataService = Get.find<UserDataService>();
  Future<List<PointageResponse>> getPointagesByVigileId() async {
    try {
      final String? userId = _authService.getUserId();
      final vigileResponse = await _vigileRepository.getVigileByUserId(
        userId ?? '',
      );
      String vigileId = vigileResponse.id;
      final url = Uri.parse('$baseUrl/pointage/byVigileId/$vigileId');
      _userDataService.setVigileId(vigileId);

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
