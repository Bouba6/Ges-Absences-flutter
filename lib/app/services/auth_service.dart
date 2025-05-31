import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/http/http_client.dart';
import 'dart:convert';

class AuthService extends GetxService {
  final storage = const FlutterSecureStorage();
  final httpClient = HttpClient(baseUrl: 'http://votre-api.com/api');
  
  final isLoggedIn = false.obs;
  final userType = ''.obs;

  Future<AuthService> init() async {
    // Vérifier si un token existe au démarrage
    final token = await storage.read(key: 'jwt_token');
    final storedUserType = await storage.read(key: 'user_type');
    
    if (token != null && storedUserType != null) {
      isLoggedIn.value = true;
      userType.value = storedUserType;
    }
    
    return this;
  }

  Future<bool> login(String email, String password, String type) async {
    try {
      final response = await httpClient.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
          'userType': type,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        await storage.write(key: 'jwt_token', value: token);
        await storage.write(key: 'user_type', value: type);
        
        isLoggedIn.value = true;
        userType.value = type;
        
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await httpClient.logout();
    isLoggedIn.value = false;
    userType.value = '';
    Get.offAllNamed('/login');
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }
} 