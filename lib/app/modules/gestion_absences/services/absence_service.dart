import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/absence_model.dart';

class AbsenceService {
  final String apiUrl = 'http://localhost:8080/api/absences';

  Future<List<Absence>> fetchAbsences() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Absence.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load absences');
    }
  }
}
