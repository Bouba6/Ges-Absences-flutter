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

Widget buildFilterDropdown() {
  return Obx(() {
    return Align(
      alignment: Alignment.centerLeft, // place le dropdown à gauche
      child: Container(
        width: 140, // fixe une largeur pas trop large
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(6),
        ),
        child: DropdownButton<StatutFiltre>(
          value: controller.filtre.value,
          isExpanded: true,
          underline: const SizedBox.shrink(), // supprime la ligne de soulignement
          items: StatutFiltre.values.map((filtre) {
            String label;
            switch (filtre) {
              case StatutFiltre.tous:
                label = 'Tous';
                break;
              case StatutFiltre.justifie:
                label = 'Justifié';
                break;
              case StatutFiltre.nonJustifie:
                label = 'Non justifié';
                break;
            }
            return DropdownMenuItem(
              value: filtre,
              child: Text(label, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (StatutFiltre? nouveauFiltre) {
            if (nouveauFiltre != null) {
              controller.changerFiltre(nouveauFiltre);
            }
          },
        ),
      ),
    );
  });
}


  Widget buildAbsenceItem(int index) {
    final absence = controller.absencesAffichees[index];
    final showJustifierButton = absence.status == 'Non justifié' || absence.status == 'Peut être justifié';

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
        padding: const EdgeInsets.all(16),
        itemCount: controller.absencesAffichees.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.absencesAffichees.length) {
            // Bouton voir plus
            final canLoadMore = controller.itemsAffiches.value < controller.absencesFiltrees.length;
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A2C2A),
        elevation: 0,
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
                    fontSize: 20,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // QR code centré
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: QrImageView(
                data: "Aminata Diop - ISM2023F9001",
                version: QrVersions.auto,
                size: 120,
              ),
            ),
          ),

          // Titre + filtre dropdown
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "HISTORIQUE D'ASSIDUITÉ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: buildFilterDropdown(),
          ),


          // Liste des absences avec pagination
          Expanded(child: buildAbsenceList()),
        ],
      ),
    );
  }
}
