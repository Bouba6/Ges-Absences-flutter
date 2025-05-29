import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    GetMaterialApp(
      title: "Gestion des Absences",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFA86A1D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA86A1D),
        ),
      ),
    ),
  );
}
