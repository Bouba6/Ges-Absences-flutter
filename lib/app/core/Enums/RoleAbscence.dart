enum Role { admin, vigile, student }

extension RoleExtension on Role {
  String get value {
    switch (this) {
      case Role.admin:
        return 'ADMIN';
      case Role.vigile:
        return 'VIGILE';
      case Role.student:
        return 'STUDENT';
    }
  }

  static Role fromString(String str) {
    switch (str.toUpperCase()) {
      case 'ADMIN':
        return Role.admin;
      case 'VIGILE':
        return Role.vigile;
      case 'STUDENT':
        return Role.student;
      default:
        throw ArgumentError('Valeur inconnue pour Role: $str');
    }
  }
}
