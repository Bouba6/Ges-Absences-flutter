import 'package:flutter/material.dart';
import 'package:gesabscences/app/modules/Abscence/views/abscence_view.dart';
import 'package:gesabscences/app/modules/Pointage/views/pointage_view.dart';

import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import 'greetingapp.dart';
import 'navBar.dart';
import '../../home/views/home_view.dart';

class MainView extends GetView<MainController> {
  MainView({super.key});

  final List<Widget> pages = [
    const PointageView(),
    const AbsenceView(),
     HomeView(),
  ];
  final List<String> titles = ['Pointage', 'Accueil', 'Étudiants'];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: GreetingAppBar(title: titles[controller.selectedIndex.value]),
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
