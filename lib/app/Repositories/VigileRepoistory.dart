import 'package:dio/dio.dart';
import 'package:gesabscences/app/Repositories/AuthRepositories.dart';
import 'package:gesabscences/app/data/dto/Response/VigileResponse.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class VigileRepository extends GetxService {
  static const String baseUrl =
      'https://ges-abscences-backend.onrender.com/api/v1/mobile';
  final Dio _dio = Dio();
  final AuthService _authService = Get.find();
  Future<VigileResponse> getVigileByUserId(String userId) async {
    final url = '$baseUrl/vigiles/user/$userId';
    print('GET $url');

    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      final data = response.data['results'];
      return VigileResponse.fromJson(data);
    } else {
      throw Exception('Erreur lors de la récupération du vigile');
    }
  }

  final Rx<VigileResponse?> vigile = Rx<VigileResponse?>(null);
  Future<void> loadVigile() async {
    final userId = _authService.getUserId();
    if (userId != null) {
      vigile.value = await this.getVigileByUserId(userId);
    }
  }

  String? get vigileId => vigile.value?.id;
}
