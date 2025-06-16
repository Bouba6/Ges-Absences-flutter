
// 1. Modifiez votre AuthResponse.dart
class AuthResponse {
  final String? token;
  final String? type; // "Bearer"
  final String? role; // "VIGILE"
  final String? userId;
  final String? nom;
  final String? prenom;
  final String? message; // Pour les erreurs
  
  AuthResponse({
    this.token,
    this.type,
    this.role,
    this.userId,
    this.nom,
    this.prenom,
    this.message,
  });
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      type: json['type'],
      role: json['role'],
      userId: json['userId'],
      nom: json['nom'],
      prenom: json['prenom'],
      message: json['message'],
    );
  }
  
  // ✅ Méthode pour créer un User à partir de cette response
  User? toUser() {
    if (userId != null) {
      return User(
        id: userId,
        login: null, // Pas dans la response du backend
        email: null, // Pas dans la response du backend
        role: role,
        nom: nom,
        prenom: prenom,
      );
    }
    return null;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'type': type,
      'role': role,
      'userId': userId,
      'nom': nom,
      'prenom': prenom,
      'message': message,
    };
  }
}

// 2. Modifiez votre classe User
class User {
  final String? id;
  final String? login;
  final String? email;
  final String? role; // ✅ Ajouté
  final String? nom; // ✅ Ajouté
  final String? prenom; // ✅ Ajouté
  
  User({
    this.id,
    this.login,
    this.email,
    this.role,
    this.nom,
    this.prenom,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      login: json['login'],
      email: json['email'],
      role: json['role'],
      nom: json['nom'],
      prenom: json['prenom'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'email': email,
      'role': role,
      'nom': nom,
      'prenom': prenom,
    };
  }
  
  // ✅ Méthodes utiles
  String get displayName {
    if (nom != null && prenom != null) {
      return '$prenom $nom';
    } else if (nom != null) {
      return nom!;
    } else if (prenom != null) {
      return prenom!;
    }
    return login ?? 'Utilisateur';
  }
  
  bool get isVigile => role == 'VIGILE';
}