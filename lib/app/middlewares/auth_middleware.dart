import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Repositories/AuthRepositories.dart';
import '../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    
    if (!authService.isLoggedIn()) {
      return const RouteSettings(name: Routes.LOGIN);
    }
    
    return null;
  }
}
