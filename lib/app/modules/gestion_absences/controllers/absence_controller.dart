import 'package:get/get.dart';
import '../models/absence_model.dart';

enum StatutFiltre { tous, justifie, nonJustifie }

class AbsenceController extends GetxController {
  var absences = <Absence>[].obs;
  var isLoading = true.obs;
  var itemsAffiches = 3.obs;
  var filtre = StatutFiltre.tous.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAbsences();
  }

  void fetchAbsences() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1)); // Simule un chargement

    final jsonData = [
      {'_id': '1', 'courseName': 'Mathématiques', 'date': '2025-05-28T08:15:00Z', 'status': 'Non justifié'},
      {'_id': '2', 'courseName': 'Physique', 'date': '2025-05-27T08:15:00Z', 'status': 'Justifié'},
      {'_id': '3', 'courseName': 'Algo', 'date': '2025-05-20T08:15:00Z', 'status': 'Non justifié'},
      {'_id': '4', 'courseName': 'Java', 'date': '2025-05-15T08:15:00Z', 'status': 'Justifié'},
      {'_id': '5', 'courseName': 'Angular', 'date': '2025-05-10T08:15:00Z', 'status': 'Non justifié'},
      {'_id': '6', 'courseName': 'PHP', 'date': '2025-05-08T08:15:00Z', 'status': 'Non justifié'},
    ];

    absences.value = jsonData.map((json) => Absence.fromJson(json)).toList();
    isLoading.value = false;
  }

  void chargerPlus() {
    if (itemsAffiches.value < absencesFiltrees.length) {
      itemsAffiches.value += 3;
    }
  }

  void justifierAbsence(int index) {
    final absence = absencesAffichees[index];
    final originalIndex = absences.indexWhere((a) => a.id == absence.id);
    if (originalIndex != -1) {
      absences[originalIndex] = Absence(
        id: absence.id,
        courseName: absence.courseName,
        date: absence.date,
        status: 'Justifié',
      );
    }
  }

  List<Absence> get absencesFiltrees {
    switch (filtre.value) {
      case StatutFiltre.justifie:
        return absences.where((a) => a.status == 'Justifié').toList();
      case StatutFiltre.nonJustifie:
        return absences.where((a) => a.status == 'Non justifié' || a.status == 'Peut être justifié').toList();
      case StatutFiltre.tous:
      default:
        return absences;
    }
  }

  List<Absence> get absencesAffichees {
    final list = absencesFiltrees;
    return list.take(itemsAffiches.value).toList();
  }

  void changerFiltre(StatutFiltre nouveauFiltre) {
    filtre.value = nouveauFiltre;
    itemsAffiches.value = 3;
  }
}
