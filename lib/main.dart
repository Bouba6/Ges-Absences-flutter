import 'package:flutter/material.dart';
import 'package:gesabscences/app/Repositories/AuthRepositories.dart';
import 'package:gesabscences/app/Repositories/userDataRepository.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart'; // 
import 'app/routes/app_pages.dart';
import 'app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD
  
  // Initialiser le service d'authentification
  await Get.putAsync(() => AuthService().init());
  
  runApp(
    GetMaterialApp(
      title: "Gestion des Absences",
      initialRoute: AppPages.INITIAL,
=======

  await GetStorage.init();
  Get.put(AuthService());
  Get.put(UserDataService());
  await Supabase.initialize(
    url:"https://kfjbpcwgbaleloidunnz.supabase.co",
    anonKey:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtmamJwY3dnYmFsZWxvaWR1bm56Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg5MDI3NTEsImV4cCI6MjA2NDQ3ODc1MX0.-Shl79TCs7_5KojuZqnBgoSbmgeZHJRKSFJjKMooC20"
  );
  final authService = Get.find<AuthService>();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: Routes.LOGIN,
>>>>>>> origin/master
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
