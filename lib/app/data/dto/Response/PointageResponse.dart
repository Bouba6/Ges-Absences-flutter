class PointageResponse {
  final String eleveId;
  final String coursId;
  final String heureArrivee; // Représentée sous forme de String (ex : "08:15:00")

  PointageResponse({
    required this.eleveId,
    required this.coursId,
    required this.heureArrivee,
  });

  factory PointageResponse.fromJson(Map<String, dynamic> json) {
    return PointageResponse(
      eleveId: json['eleveId'] as String ,
      coursId: json['coursId'] as String,
      heureArrivee: json['heureArrivee'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eleveId': eleveId,
      'coursId': coursId,
      'heureArrivee': heureArrivee,
    };
  }
}
