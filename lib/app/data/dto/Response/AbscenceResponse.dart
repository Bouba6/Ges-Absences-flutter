class Abscenceresponse {
  final String id;
  final String eleveId;
  final String statutAbscence;
  final String coursId;

  Abscenceresponse({
    required this.id,
    required this.coursId,
    required this.eleveId,
    required this.statutAbscence,
  });

  factory Abscenceresponse.fromJson(Map<String, dynamic> json) {
    return Abscenceresponse(
      id: json['id']?.toString() ?? '',
      eleveId: json['eleveId']?.toString() ?? '',
      coursId: json['coursId']?.toString() ?? '',
      statutAbscence: json['statutAbscence']?.toString() ?? 'NON_JUSTIFIER',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eleveId': eleveId,
      'coursId': coursId,
      'statutAbscence': statutAbscence,
    };
  }
}
