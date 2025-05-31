import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpClient {
  final storage = const FlutterSecureStorage();
  final String baseUrl;
  
  HttpClient({required this.baseUrl});
  
  Future<http.Response> get(String endpoint) async {
    final token = await storage.read(key: 'jwt_token');
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
  
  Future<http.Response> post(String endpoint, {required Map<String, dynamic> body}) async {
    final token = await storage.read(key: 'jwt_token');
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );
  }
  
  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'user_type');
  }
} 