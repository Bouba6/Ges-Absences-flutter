import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/absence_controller.dart';

class AbsenceListView extends StatelessWidget {
  final AbsenceController controller = Get.put(AbsenceController());

  AbsenceListView({super.key});

  String formatDate(DateTime date) =>
      DateFormat('dd/MM/yyyy – HH:mm').format(date);

  Color getStatusColor(String status) {
    switch (status) {
      case 'Justifié':
        return Colors.green.shade700;
      case 'Non justifié':
        return Colors.red.shade700;
      case 'Peut être justifié':
        return Colors.orange.shade700;
      default:
        return Colors.grey;
    }
  }

  Widget buildFiltreDropdown() {
    return Obx(() {
      return DropdownButton<StatutFiltre>(
        value: controller.filtre.value,
        icon: const Icon(Icons.keyboard_arrow_down),
        underline: Container(height: 1, color: Colors.grey.shade300),
        onChanged: (newValue) {
          if (newValue != null) {
            controller.changerFiltre(newValue);
          }
        },
        items: const [
          DropdownMenuItem(
            value: StatutFiltre.tous,
            child: Text('Tous'),
          ),
          DropdownMenuItem(
            value: StatutFiltre.justifie,
            child: Text('Justifié'),
          ),
          DropdownMenuItem(
            value: StatutFiltre.nonJustifie,
            child: Text('Non justifié'),
          ),
        ],
      );
    });
  }

  Widget buildAbsenceItem(int index) {
    final absence = controller.absencesAffichees[index];
    final showJustifierButton =
        absence.status == 'Non justifié' || absence.status == 'Peut être justifié';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Infos cours + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  absence.courseName,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
                Text(
                  formatDate(absence.date),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                ),
              ],
            ),
          ),
          // Statut couleur
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              absence.status,
              style: TextStyle(
                color: getStatusColor(absence.status),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          // Bouton Justifier
          if (showJustifierButton)
            ElevatedButton(
              onPressed: () => controller.justifierAbsence(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A2C2A),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text(
                "Justifier",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildAbsenceList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.absencesAffichees.isEmpty) {
        return const Center(child: Text('Aucune absence enregistrée.'));
      }

      return ListView.builder(
        padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
        itemCount: controller.absencesAffichees.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.absencesAffichees.length) {
            final canLoadMore =
                controller.itemsAffiches.value < controller.absencesFiltrees.length;
            return canLoadMore
                ? Center(
                    child: ElevatedButton(
                      onPressed: controller.chargerPlus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5A623),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: const Text(
                        "Voir plus",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }
          return buildAbsenceItem(index);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(
            children: [
              AppBar(
                backgroundColor: const Color(0xFF4A2C2A),
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: const AssetImage('assets/avatar_placeholder.png'),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Aminata Diop",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "ID: ISM2023F9001",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.logout, color: Color(0xFFF5A623)),
                  ),
                ],
              ),
              // QR
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: QrImageView(
                  data: "Aminata Diop - ISM2023F9001",
                  version: QrVersions.auto,
                  size: 120,
                ),
              ),
              const SizedBox(height: 16),

              // Titre + Filtre dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Historique d’assiduité",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                      child: buildFiltreDropdown(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              Expanded(child: buildAbsenceList()),
            ],
          ),
        ),
      ),
    );
  }
}
