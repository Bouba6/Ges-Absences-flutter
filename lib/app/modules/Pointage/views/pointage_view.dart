import 'package:flutter/material.dart';
import 'package:gesabscences/app/core/Enums/pointageState.dart';
import 'package:gesabscences/app/data/dto/Response/PointageResponse.dart';
import 'package:get/get.dart';
import '../controllers/pointage_controller.dart';

class PointageView extends StatelessWidget {
  const PointageView({super.key});

  // Palette de couleurs personnalisée
  static const Color primaryDark = Color(0xFF351F16); // #351F16
  static const Color primaryOrange = Color(0xFFF58613); // #F58613
  static const Color white = Color(0xFFFFFFFF); // #FFFFFF
  static const Color black = Color(0xFF000000); // #000000

  @override
  Widget build(BuildContext context) {
    final PointageController controller = Get.put(PointageController());

    return Obx(() {
      switch (controller.state.value) {
        case PointageState.loading:
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: primaryOrange),
                const SizedBox(height: 16),
                Text(
                  'Chargement des pointages...',
                  style: TextStyle(color: primaryDark),
                ),
              ],
            ),
          );

        case PointageState.error:
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: primaryOrange),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: primaryDark),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => controller.refresh(),
                    icon: Icon(Icons.refresh, color: white, size: 18),
                    label: Text('Réessayer', style: TextStyle(color: white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      foregroundColor: white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

        case PointageState.empty:
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, size: 64, color: primaryOrange),
                const SizedBox(height: 16),
                Text(
                  'Aucun pointage trouvé',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aucun pointage n\'a été enregistré pour le moment.',
                  style: TextStyle(color: primaryDark.withOpacity(0.7)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => controller.refresh(),
                  icon: Icon(Icons.refresh, color: white, size: 18),
                  label: Text('Actualiser', style: TextStyle(color: white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: white,
                  ),
                ),
              ],
            ),
          );

        case PointageState.loaded:
          return RefreshIndicator(
            onRefresh: () => controller.refresh(),
            color: primaryOrange,
            backgroundColor: white,
            child: Column(
              children: [
                // En-tête avec statistiques
                _buildStatisticsHeader(controller),

                // Liste des pointages
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.pointages.length,
                    itemBuilder: (context, index) {
                      final pointage = controller.pointages[index];
                      return _buildPointageCard(pointage, index);
                    },
                  ),
                ),
              ],
            ),
          );
      }
    });
  }

  Widget _buildStatisticsHeader(PointageController controller) {
    final totalPointages = controller.pointages.length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time, color: primaryOrange, size: 24),
          const SizedBox(width: 8),
          Text(
            'Total des pointages: ',
            style: TextStyle(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            totalPointages.toString(),
            style: TextStyle(
              color: primaryOrange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointageCard(PointageResponse pointage, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      color: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryDark.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar avec numéro
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: primaryOrange,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Informations du pointage
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre avec ID élève
                  Text(
                    'Élève: ${pointage.eleveId}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primaryDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Informations détaillées
                  _buildInfoItem(Icons.class_, 'Cours', pointage.coursId),

                  const SizedBox(height: 4),

                  _buildInfoItem(
                    Icons.schedule,
                    'Arrivée',
                    pointage.heureArrivee,
                  ),
                ],
              ),
            ),

            // Icône de statut
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.check_circle, color: primaryOrange, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: primaryDark.withOpacity(0.6)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            color: primaryDark.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: primaryDark,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
