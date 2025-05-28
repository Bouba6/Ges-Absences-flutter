enum UserRole { vigile, etudiant, admin }

class User {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final UserRole role;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
  });
}