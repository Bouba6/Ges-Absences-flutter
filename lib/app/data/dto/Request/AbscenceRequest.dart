class UpdateAbsenceRequest {
  final String statutAbscence;
  final String eleveId;
  final String? justificatifId;
  final String coursId;
  final String typeAbscence;

  UpdateAbsenceRequest({
    required this.statutAbscence,
    required this.eleveId,
    this.justificatifId,
    required this.coursId,
    required this.typeAbscence,
  });

  Map<String, dynamic> toJson() {
    return {
      'statutAbscence': statutAbscence,
      'eleveId': eleveId,
      'justificatifId': justificatifId,
      'coursId': coursId,
      'typeAbscence': typeAbscence,
    };
  }
}
