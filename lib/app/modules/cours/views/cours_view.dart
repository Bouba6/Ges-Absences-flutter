import 'package:flutter/material.dart';
import 'package:gesabscences/app/data/dto/Response/CoursResponse.dart';
import 'package:get/get.dart';
import '../controllers/cours_controller.dart';
import 'package:intl/intl.dart';

class CoursView extends GetView<CoursController> {
  const CoursView({super.key});

  // Vos couleurs
  static const Color primaryDark = Color(0xFF351F16);
  static const Color primaryOrange = Color(0xFFF58613);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text(
          'Mes Cours d\'Aujourd\'hui',
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryDark,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: white),
            onPressed: () => controller.fetchCours(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryOrange),
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: primaryOrange,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: primaryDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchCours(),
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

        if (controller.coursList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  size: 80,
                  color: primaryOrange,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Aucun cours aujourd\'hui',
                  style: TextStyle(
                    fontSize: 18,
                    color: primaryDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: primaryOrange,
          onRefresh: () => controller.fetchCours(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.coursList.length,
            itemBuilder: (context, index) {
              final cours = controller.coursList[index];
              return CoursCard(cours: cours);
            },
          ),
        );
      }),
    );
  }
}

class CoursCard extends StatelessWidget {
  final Cours cours;
  
  // Vos couleurs
  static const Color primaryDark = Color(0xFF351F16);
  static const Color primaryOrange = Color(0xFFF58613);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  const CoursCard({super.key, required this.cours});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              white,
              primaryOrange.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cours.nomModule,
                      style: const TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.school,
                    color: primaryDark,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                cours.nomCours,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: primaryDark.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Prof. ${cours.nomProfesseur}',
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryDark.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.class_,
                    size: 16,
                    color: primaryDark.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    cours.nomClasse,
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryDark.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryDark.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: primaryOrange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${cours.getFormattedHeureDebut()} - ${cours.getFormattedHeureFin()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryDark,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      cours.getFormattedDate(),
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryDark.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}