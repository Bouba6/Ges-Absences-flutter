// views/absence_view.dart
import 'package:flutter/material.dart';
import 'package:gesabscences/app/core/Enums/AbscenceState.dart';
import 'package:gesabscences/app/data/dto/Response/AbscenceResponse.dart';
import 'package:gesabscences/app/modules/Abscence/controllers/abscence_controller.dart';
import 'package:get/get.dart';

class AbsenceView extends StatelessWidget {
  const AbsenceView({super.key});

  // Palette de couleurs personnalisée
  static const Color primaryDark = Color(0xFF351F16); // #351F16
  static const Color primaryOrange = Color(0xFFF58613); // #F58613
  static const Color white = Color(0xFFFFFFFF); // #FFFFFF
  static const Color black = Color(0xFF000000); // #000000

  @override
  Widget build(BuildContext context) {
    final AbscenceController controller = Get.put(AbscenceController());

    return Obx(() {
      // Overlay de chargement pour les actions
      return Stack(
        children: [
          _buildMainContent(controller),
          if (controller.isUpdating.value)
            Container(
              color: primaryDark.withOpacity(0.7),
              child: Center(
                child: Card(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: primaryOrange),
                        const SizedBox(height: 16),
                        Text(
                          'Mise à jour en cours...',
                          style: TextStyle(color: primaryDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildMainContent(AbscenceController controller) {
    switch (controller.state.value) {
      case AbsenceState.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: primaryOrange),
              const SizedBox(height: 16),
              Text(
                'Chargement des absences...',
                style: TextStyle(color: primaryDark),
              ),
            ],
          ),
        );

      case AbsenceState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: primaryOrange),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: primaryDark),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => controller.refresh(),
                  icon: Icon(Icons.refresh, color: white),
                  label: Text('Réessayer', style: TextStyle(color: white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: white,
                  ),
                ),
              ],
            ),
          ),
        );

      case AbsenceState.empty:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 64, color: primaryOrange),
              const SizedBox(height: 16),
              Text(
                'Aucune absence trouvée',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cet élève n\'a pas d\'absences enregistrées.',
                style: TextStyle(color: primaryDark),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => controller.refresh(),
                icon: Icon(Icons.refresh, color: white),
                label: Text('Actualiser', style: TextStyle(color: white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  foregroundColor: white,
                ),
              ),
            ],
          ),
        );

      case AbsenceState.loaded:
        return RefreshIndicator(
          onRefresh: () => controller.refresh(),
          color: primaryOrange,
          backgroundColor: white,
          child: _buildAbsencesList(controller),
        );
    }
  }

  Widget _buildAbsencesList(AbscenceController controller) {
    return Column(
      children: [
        // Statistiques en haut
        _buildStatisticsCard(controller),

        // Liste des absences
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.absences.length,
            itemBuilder: (context, index) {
              final absence = controller.absences[index];
              return _buildAbsenceCard(absence, controller);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard(AbscenceController controller) {
    final total = controller.absences.length;
    final justifiees =
        controller.absences
            .where((absence) => absence.statutAbscence == 'JUSTIFIER')
            .length;
    final nonJustifiees =
        controller.absences
            .where((absence) => absence.statutAbscence == 'NON_JUSTIFIER')
            .length;

    return Card(
      margin: const EdgeInsets.all(16),
      color: white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryDark.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Total', total, primaryDark),
            _buildStatItem('Justifiées', justifiees, primaryOrange),
            _buildStatItem(
              'Non justifiées',
              nonJustifiees,
              primaryOrange.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: primaryDark)),
      ],
    );
  }

  Widget _buildAbsenceCard(
    Abscenceresponse absence,
    AbscenceController controller,
  ) {
    final String isJustified =
        absence.statutAbscence == 'JUSTIFIER' ? 'Justifiée' : 'Non justifiée';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec statut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Absence #${absence.id}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryDark,
                    ),
                  ),
                ),
                _buildStatusChip(absence),
              ],
            ),

            const SizedBox(height: 12),

            // Informations de l'absence
            _buildInfoRow(Icons.person, 'Élève ID', absence.eleveId),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.class_, 'Cours ID', absence.coursId),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.info,
              'Statut',
              _getStatusLabel(absence.statutAbscence),
            ),

            const SizedBox(height: 16),

            // Boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isJustified == true) ...[
                  ElevatedButton.icon(
                    onPressed: () => controller.marquerNonJustifiee(absence),
                    icon: Icon(Icons.cancel, size: 18, color: white),
                    label: Text(
                      'Retirer justification',
                      style: TextStyle(color: white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryDark,
                      foregroundColor: white,
                    ),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: () => controller.justifierAbsence(absence),
                    icon: Icon(Icons.check, size: 18, color: white),
                    label: Text('Justifier', style: TextStyle(color: white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      foregroundColor: white,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(Abscenceresponse absence) {
    final bool isJustified = absence.statutAbscence == 'JUSTIFIER';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isJustified ? primaryOrange : primaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getStatusLabel(absence.statutAbscence),
        style: const TextStyle(
          color: white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: primaryDark.withOpacity(0.7)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontWeight: FontWeight.w500, color: primaryDark),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: primaryDark.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'JUSTIFIER':
        return 'Justifiée';
      case 'NON_JUSTIFIER':
        return 'Non justifiée';
      default:
        return status;
    }
  }
}
