import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/absence_controller.dart';

class AbsenceListView extends StatelessWidget {
  final AbsenceController controller = Get.put(AbsenceController());

  AbsenceListView({super.key});

  String formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return "Aujourd'hui ${DateFormat('HH:mm').format(date)}";
    } else if (date.difference(now).inDays == -1) {
      return "Hier - ${DateFormat('HH:mm').format(date)}";
    } else {
      return DateFormat('dd/MM/yy - HH:mm').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === En-tête étudiant avec logout ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            'https://static.vecteezy.com/system/resources/previews/019/879/186/large_2x/user-icon-on-transparent-background-free-png.png',
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Henoc Mampouya',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 4),
                            Text('Matricule : 20230001',
                                style: TextStyle(fontSize: 14, color: Colors.grey)),
                            Text('Niveau : L3 GLS',
                                style: TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.black),
                      onPressed: () {
                        // TODO: déconnexion
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // === Liste des absences ===
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.absences.length,
                          itemBuilder: (context, index) {
                            final absence = controller.absences[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    absence.courseName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Color(0xFF4A2C2A),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    formatDate(absence.date),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        absence.status,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: absence.status == 'Justifié'
                                              ? const Color(0xFF006400)
                                              : const Color(0xFF8B0000),
                                        ),
                                      ),
                                      if (absence.status == 'Non justifié')
                                        ElevatedButton(
                                          onPressed: () {
                                            // TODO: Implémenter justification
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFB8701E),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Justifier',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // === Bouton Voir plus ===
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Charger plus ou aller à l’historique complet
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB8701E),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Voir plus',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
