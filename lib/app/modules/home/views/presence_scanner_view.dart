import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class PresenceScannerView extends GetView<HomeController> {
  const PresenceScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person, size: 28),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Abdoulaye', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Sagna', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {
                      controller.seDeconnecter();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Scanner Présence',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 250,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA86A1D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () async {
                        final scannedId = await Get.toNamed(Routes.SCANNER);
                        if (scannedId != null) {
                          print('Scanned ID received: $scannedId');
                          final etudiant = controller.findEtudiantByMatricule(scannedId);
                          if (etudiant != null) {
                            controller.addPointage(etudiant);
                            Get.snackbar('Succès', 'Pointage enregistré pour ${etudiant.prenom} ${etudiant.nom}', snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar('Erreur', 'Étudiant non trouvé avec le matricule $scannedId', snackPosition: SnackPosition.BOTTOM);
                          }
                        }
                      },
                      child: const Text('Ouvrir le scanner', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Saisie manuelle',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.studentIdController,
                decoration: InputDecoration(
                  hintText: 'ID Etudiant(ISM2223DK)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA86A1D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    final manualId = controller.studentIdController.text;
                    if (manualId.isNotEmpty) {
                      final etudiant = controller.findEtudiantByMatricule(manualId);
                      if (etudiant != null) {
                        controller.addPointage(etudiant);
                        Get.snackbar('Succès', 'Pointage enregistré pour ${etudiant.prenom} ${etudiant.nom}', snackPosition: SnackPosition.BOTTOM);
                        controller.clearStudentIdField();
                      } else {
                        Get.snackbar('Erreur', 'Étudiant non trouvé avec le matricule $manualId', snackPosition: SnackPosition.BOTTOM);
                      }
                    } else {
                      Get.snackbar('Attention', 'Veuillez saisir un matricule', snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Historique de pointage',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFA86A1D),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                        child: Text('Étudiant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('Heure', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.historiquePointage.length,
                  itemBuilder: (context, index) {
                    final pointage = controller.historiquePointage[index];
                    return _HistoriqueRow(nom: pointage['nom']!, heure: pointage['heure']!);
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoriqueRow extends StatelessWidget {
  final String nom;
  final String heure;
  const _HistoriqueRow({required this.nom, required this.heure, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
        child: Row(
          children: [
            Expanded(child: Text(nom, style: const TextStyle(fontWeight: FontWeight.w500))),
            Text(heure, style: const TextStyle(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
} 