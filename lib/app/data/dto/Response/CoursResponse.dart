class Cours {
  final String id;
  final String nomCours;
  final String idClasse;
  final String nomClasse;
  final String nomProfesseur;
  final String nomModule;
  final int nbHeures;
  final DateTime heureDebut;
  final DateTime heureFin;
  final String date;

  Cours({
    required this.id,
    required this.nomCours,
    required this.idClasse,
    required this.nomClasse,
    required this.nomProfesseur,
    required this.nomModule,
    required this.nbHeures,
    required this.heureDebut,
    required this.heureFin,
    required this.date,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      id: json['id'] ?? '',
      nomCours: json['nomCours'] ?? '',
      idClasse: json['idClasse'] ?? '',
      nomClasse: json['nomClasse'] ?? '',
      nomProfesseur: json['nomProfesseur'] ?? '',
      nomModule: json['nomModule'] ?? '',
      nbHeures: json['nbHeures'] ?? 0,
      heureDebut: DateTime.parse(json['heureDebut']),
      heureFin: DateTime.parse(json['heureFin']),
      date: json['date'] ?? '',
    );
  }

  String getFormattedHeureDebut() {
    return "${heureDebut.hour.toString().padLeft(2, '0')}:${heureDebut.minute.toString().padLeft(2, '0')}";
  }

  String getFormattedHeureFin() {
    return "${heureFin.hour.toString().padLeft(2, '0')}:${heureFin.minute.toString().padLeft(2, '0')}";
  }

  String getFormattedDate() {
    return "${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)}";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomCours': nomCours,
      'idClasse': idClasse,
      'nomClasse': nomClasse,
      'nomProfesseur': nomProfesseur,
      'nomModule': nomModule,
      'nbHeures': nbHeures,
      'heureDebut': heureDebut.toIso8601String(),
      'heureFin': heureFin.toIso8601String(),
      'date': date,
    };
  }
}
