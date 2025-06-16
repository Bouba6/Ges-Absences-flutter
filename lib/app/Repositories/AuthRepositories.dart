import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/dto/Response/AuthResponse.dart';

class AuthService extends GetxService {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();

  static const String baseUrl = 'https://ges-abscences-backend.onrender.com/api';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String authDataKey =
      'auth_data'; // ✅ Pour stocker toute la response

  @override
  void onInit() {
    super.onInit();
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10).inMilliseconds;
    _dio.options.receiveTimeout = const Duration(seconds: 10).inMilliseconds;

    // Intercepteur pour ajouter le token automatiquement
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // ✅ Gestion automatique des erreurs 401 (token expiré)
          if (error.response?.statusCode == 401) {
            logout(); // Déconnexion automatique
            Get.offAllNamed('/login'); // Redirection vers login
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<AuthResponse> login(String login, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'login': login, 'password': password},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response data: ${response.data}'); // ✅ Debug

      final authResponse = AuthResponse.fromJson(response.data);

      if (authResponse.token != null) {
        // ✅ Sauvegarde du token
        await saveToken(authResponse.token!);

        // ✅ Sauvegarde des données utilisateur
        final user = authResponse.toUser();
        if (user != null) {
          await saveUser(user);
        }

        // ✅ Sauvegarde de toute la response d'auth pour référence
        await saveAuthData(authResponse);
      }

      return authResponse;
    } on DioError catch (e) {
      print('Dio error: ${e.response?.data}'); // ✅ Debug

      if (e.response != null) {
        // ✅ Gestion des erreurs du serveur
        final errorData = e.response!.data;
        String errorMessage = 'Erreur de connexion';

        if (errorData is Map<String, dynamic>) {
          errorMessage =
              errorData['message'] ??
              errorData['error'] ??
              'Identifiants incorrects';
        } else if (errorData is String) {
          errorMessage = errorData;
        }

        return AuthResponse(message: errorMessage);
      }
      return AuthResponse(message: 'Erreur réseau - Vérifiez votre connexion');
    } catch (e) {
      print('Unknown error: $e'); // ✅ Debug
      return AuthResponse(message: 'Erreur inconnue: ${e.toString()}');
    }
  }

  Future<void> saveToken(String token) async {
    await _storage.write(tokenKey, token);
  }

  Future<void> saveUser(User user) async {
    await _storage.write(userKey, user.toJson());
  }

  Future<void> saveAuthData(AuthResponse authResponse) async {
    await _storage.write(authDataKey, authResponse.toJson());
  }

  String? getToken() {
    return _storage.read(tokenKey);
  }

  User? getUser() {
    final userData = _storage.read(userKey);
    if (userData != null) {
      return User.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  AuthResponse? getAuthData() {
    final authData = _storage.read(authDataKey);
    if (authData != null) {
      return AuthResponse.fromJson(Map<String, dynamic>.from(authData));
    }
    return null;
  }

  String? getUserRole() {
    return getUser()?.role ?? getAuthData()?.role;
  }

  String? getUserId() {
    return getUser()?.id ?? getAuthData()?.userId;
  }

  bool isLoggedIn() {
    return getToken() != null;
  }

  bool isVigile() {
    return getUserRole() == 'VIGILE';
  }

  Future<void> logout() async {
    await _storage.remove(tokenKey);
    await _storage.remove(userKey);
    await _storage.remove(authDataKey);
  }
}

// 4. Exemple d'utilisation dans un controller
class ProfileController extends GetxController {
  final AuthService _authService = Get.find();

  User? get currentUser => _authService.getUser();
  String? get userRole => _authService.getUserRole();
  bool get isVigile => _authService.isVigile();

  String get displayName {
    final user = currentUser;
    return user?.displayName ?? 'Utilisateur';
  }

  String get userInfo {
    final authData = _authService.getAuthData();
    if (authData != null) {
      return 'Role: ${authData.role}\nID: ${authData.userId}';
    }
    return 'Aucune information';
  }
}
