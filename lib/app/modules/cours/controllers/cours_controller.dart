import 'package:gesabscences/app/Repositories/AuthRepositories.dart';
import 'package:gesabscences/app/Repositories/EleveRepositories.dart';
import 'package:gesabscences/app/data/dto/Response/CoursResponse.dart';
import 'package:gesabscences/app/data/dto/Response/Eleveesponse.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoursController extends GetxController {
  // Variables observables
  var coursList = <Cours>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final EleveRepository _eleveRepository = Get.put<EleveRepository>(
    EleveRepository(),
  );

  // Service d'authentification (remplacez par votre implémentation)
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    fetchCours();
  }

  // Méthode pour récupérer les cours
  Future<void> fetchCours() async {
    String eleveId;
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Récupérer l'ID de l'utilisateur connecté
      final String? userId = _authService.getUserId();

      if (userId == null) {
        errorMessage.value = "Utilisateur non connecté";
        isLoading.value = false;
        return;
      }
      EleveResponse eleveResponse = await _eleveRepository.getEleveByUserId(
        userId ?? '',
      );
      eleveId = eleveResponse.id;
      if (eleveId == null) {
        throw Exception(
          "ID utilisateur non trouvé. L'utilisateur n'est peut-être pas connecté.",
        );
      }

      final response = await http.get(
        Uri.parse(
          'https://ges-abscences-backend.onrender.com/api/v1/cours/eleve/$eleveId/today',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 200 && data['results'] != null) {
          final List<dynamic> coursData = data['results'];
          coursList.value =
              coursData.map((json) => Cours.fromJson(json)).toList();

          // Optionnel: trier les cours par heure de début
          coursList.sort((a, b) => a.heureDebut.compareTo(b.heureDebut));
        } else {
          errorMessage.value = "Aucun cours trouvé";
        }
      } else {
        errorMessage.value =
            "Erreur lors du chargement des cours (${response.statusCode})";
      }
    } catch (e) {
      errorMessage.value = "Erreur de connexion: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour rafraîchir les cours
  Future<void> refreshCours() async {
    await fetchCours();
  }

  // Méthode pour obtenir le nombre de cours
  int get coursCount => coursList.length;

  // Méthode pour vérifier si des cours sont programmés
  bool get hasCoursToday => coursList.isNotEmpty;

  // Méthode pour obtenir le prochain cours
  Cours? get nextCours {
    final now = DateTime.now();
    for (var cours in coursList) {
      if (cours.heureDebut.isAfter(now)) {
        return cours;
      }
    }
    return null;
  }

  // Méthode pour vérifier si un cours est en cours
  bool isCoursEnCours(Cours cours) {
    final now = DateTime.now();
    return now.isAfter(cours.heureDebut) && now.isBefore(cours.heureFin);
  }

  // Méthode pour obtenir le cours en cours (s'il y en a un)
  Cours? get coursEnCours {
    final now = DateTime.now();
    for (var cours in coursList) {
      if (isCoursEnCours(cours)) {
        return cours;
      }
    }
    return null;
  }
}
