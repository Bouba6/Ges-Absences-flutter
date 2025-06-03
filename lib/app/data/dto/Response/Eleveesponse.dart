class EleveResponse {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final DateTime dateNaissance;
  final String sexe;
  final String adresse;
  final String ville;
  final String nomClasse;

  EleveResponse({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.dateNaissance,
    required this.sexe,
    required this.adresse,
    required this.ville,
    required this.nomClasse,
  });

  factory EleveResponse.fromJson(Map<String, dynamic> json) {
    return EleveResponse(
      id: json['id'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String,
      dateNaissance: DateTime.parse(json['dateNaissance'] as String),
      sexe: json['sexe'] as String,
      adresse: json['adresse'] as String,
      ville: json['ville'] as String,
      nomClasse: json['nomClasse'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'dateNaissance': dateNaissance.toIso8601String(),
      'sexe': sexe,
      'adresse': adresse,
      'ville': ville,
      'nomClasse': nomClasse,
    };
  }
}
