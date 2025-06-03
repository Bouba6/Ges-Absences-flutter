class VigileResponse {
  final String id;
  final String nom;
  final String? login;
  final String? password;

  VigileResponse({
    required this.id,
    required this.nom,
    this.login,
    this.password,
  });

  factory VigileResponse.fromJson(Map<String, dynamic> json) {
    return VigileResponse(
      id: json['id'],
      nom: json['nom'],
      login: json['login'],
      password: json['password'],
    );
  }
}
