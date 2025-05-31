import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des élèves'),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }
        if (controller.eleves.isEmpty) {
          return Center(child: Text('Aucun élève trouvé'));
        }

        return ListView.builder(
          itemCount: controller.eleves.length,
          itemBuilder: (context, index) {
            final eleve = controller.eleves[index];
            return ListTile(
              title: Text('${eleve.nom} ${eleve.prenom}'),
              subtitle: Text(eleve.email),
              trailing: Text(eleve.ville),
            );
          },
        );
      }),
    );
  }
}
