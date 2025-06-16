import 'package:flutter/material.dart';
import 'package:gesabscences/app/Repositories/AuthRepositories.dart';
import 'package:gesabscences/app/Repositories/VigileRepoistory.dart';
import 'package:gesabscences/app/Repositories/userDataRepository.dart';
import 'package:gesabscences/app/modules/home/views/Widgets/scanner_diagnostic.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../Repositories/EleveRepositories.dart';

class HomeView extends GetView<HomeController> {
<<<<<<< HEAD
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Absences'),
        backgroundColor: const Color(0xFFA86A1D),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenue dans l\'application de gestion des absences',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Ajouter la navigation vers la page de gestion des absences
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA86A1D),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Gérer les absences'),
            ),
          ],
=======
  HomeView({Key? key}) : super(key: key);

  // Couleurs personnalisées
  static const Color primaryDark = Color(0xFF351F16);
  static const Color primaryOrange = Color(0xFFF58613);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    final UserDataService _userDataService = Get.find<UserDataService>();
    // final UserDataService _userDataService = Get.put(UserDataService());
    final String? vigileId = _userDataService.getVigileId;
    if (vigileId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Section Scanner et Recherche
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryDark.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              // Bouton Scanner
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => controller.openScanner(),
                  icon: const Icon(Icons.qr_code_scanner, size: 24),
                  label: const Text(
                    'Scanner un QR Code',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark,
                    foregroundColor: white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Divider avec texte
              Row(
                children: [
                  Expanded(child: Divider(color: primaryDark.withOpacity(0.3))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OU',
                      style: TextStyle(
                        color: primaryDark.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: primaryDark.withOpacity(0.3))),
                ],
              ),

              const SizedBox(height: 16),

              // Champ de recherche
              TextField(
                decoration: InputDecoration(
                  hintText: 'Saisir l\'ID de l\'élève',
                  hintStyle: TextStyle(color: primaryDark.withOpacity(0.5)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: primaryDark.withOpacity(0.7),
                  ),
                  suffixIcon: Obx(
                    () =>
                        controller.loadingEleve.value
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: primaryOrange,
                              ),
                            )
                            : Icon(
                              Icons.person_search,
                              color: primaryDark.withOpacity(0.7),
                            ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primaryDark.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primaryOrange, width: 2),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    controller.findEleveById(value);
                  }
                },
              ),
            ],
          ),
>>>>>>> origin/master
        ),

        // Résultat de la recherche
        Obx(() {
          if (controller.selectedEleve.value != null) {
            final eleve = controller.selectedEleve.value!;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Card(
                elevation: 2,
                color: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: primaryOrange.withOpacity(0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryOrange,
                            child: Text(
                              '${eleve.prenom?.substring(0, 1) ?? ''}${eleve.nom?.substring(0, 1) ?? ''}',
                              style: const TextStyle(
                                color: white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${eleve.prenom ?? ''} ${eleve.nom ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryDark,
                                  ),
                                ),
                                Text(
                                  'ID: ${eleve.id ?? 'N/A'}',
                                  style: TextStyle(
                                    color: primaryDark.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                                if (eleve.nomClasse != null)
                                  Text(
                                    'Classe: ${eleve.nomClasse}',
                                    style: TextStyle(
                                      color: primaryDark.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => ElevatedButton.icon(
                            onPressed:
                                controller.validatingPresence.value ||
                                        vigileId == null
                                    ? null
                                    : () {
                                      final String eleveId =
                                          eleve.id.toString();
                                      final String idVigile = vigileId;

                                      controller.validerPresence(
                                        eleveId,
                                        idVigile,
                                      );
                                    },
                            icon:
                                controller.validatingPresence.value
                                    ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: white,
                                      ),
                                    )
                                    : const Icon(Icons.check_circle),
                            label: Text(
                              controller.validatingPresence.value
                                  ? 'Validation en cours...'
                                  : 'Valider la Présence',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryOrange,
                              foregroundColor: white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        const SizedBox(height: 8),

        // Liste de tous les élèves
        Expanded(
          child: Obx(() {
            if (controller.loading.value) {
              return Center(
                child: CircularProgressIndicator(color: primaryOrange),
              );
            }

            if (controller.error.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: primaryOrange.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur de chargement',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.error.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: primaryDark.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.loadEleves(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        foregroundColor: white,
                      ),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }

            if (controller.eleves.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: primaryDark.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun élève trouvé',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryDark.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.loadEleves(),
              color: primaryOrange,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: controller.eleves.length,
                itemBuilder: (context, index) {
                  final eleve = controller.eleves[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    elevation: 1,
                    color: white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: primaryDark.withOpacity(0.1)),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryDark.withOpacity(0.1),
                        child: Text(
                          '${eleve.prenom?.substring(0, 1) ?? ''}${eleve.nom?.substring(0, 1) ?? ''}',
                          style: const TextStyle(
                            color: primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        '${eleve.prenom ?? ''} ${eleve.nom ?? ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: primaryDark,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ${eleve.id ?? 'N/A'}',
                            style: TextStyle(
                              color: primaryDark.withOpacity(0.7),
                            ),
                          ),
                          if (eleve.nomClasse != null)
                            Text(
                              'Classe: ${eleve.nomClasse}',
                              style: TextStyle(
                                color: primaryDark.withOpacity(0.7),
                              ),
                            ),
                        ],
                      ),
                      trailing: Obx(
                        () => ElevatedButton.icon(
                          onPressed:
                              controller.validatingPresence.value ||
                                      vigileId == null
                                  ? null
                                  : () {
                                    final String eleveId = eleve.id.toString();
                                    final String idVigile = vigileId;
                                    controller.validerPresence(
                                      eleveId,
                                      idVigile,
                                    );
                                  },
                          icon:
                              controller.validatingPresence.value
                                  ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: white,
                                    ),
                                  )
                                  : const Icon(Icons.check, size: 16),
                          label: const Text('Valider'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryOrange,
                            foregroundColor: white,
                            minimumSize: const Size(80, 32),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
