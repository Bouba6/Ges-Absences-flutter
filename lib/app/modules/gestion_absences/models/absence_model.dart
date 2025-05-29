class Absence {
  final String id;
  final String courseName;
  final DateTime date;
  final String status; // "Justifié" ou "Non justifié"

  Absence({
    required this.id,
    required this.courseName,
    required this.date,
    required this.status,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['_id'] ?? '',
      courseName: json['courseName'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'Non justifié',
    );
  }
}
