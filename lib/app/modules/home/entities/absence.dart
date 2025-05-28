class Absence {
  final String id;
  final String etudiantId;
  final DateTime date;
  final bool justifiee;
  final String? justification;

  Absence({
    required this.id,
    required this.etudiantId,
    required this.date,
    this.justifiee = false,
    this.justification,
  });
}