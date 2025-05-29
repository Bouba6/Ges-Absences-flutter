import 'package:get/get.dart';
import '../models/absence_model.dart';

class AbsenceController extends GetxController {
  var absences = <Absence>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAbsences();
  }

  void fetchAbsences() async {
    await Future.delayed(const Duration(seconds: 1)); // Simule latence

    // Simulation de données JSON (à remplacer par service réel)
final jsonData = [
  {'_id': '1', 'courseName': 'Mathématiques', 'date': '2025-05-28T08:15:00Z', 'status': 'Non justifié'},
  {'_id': '2', 'courseName': 'Physique', 'date': '2025-05-27T08:15:00Z', 'status': 'Justifié'},
  {'_id': '3', 'courseName': 'Algo', 'date': '2025-05-20T08:15:00Z', 'status': 'Non justifié'},
  {'_id': '4', 'courseName': 'Java', 'date': '2025-05-15T08:15:00Z', 'status': 'Justifié'}
];



    absences.value = jsonData.map((json) => Absence.fromJson(json)).toList();
    isLoading.value = false;
  }
}
