enum TypeAbsence { absent, retard }

extension TypeAbsenceExtension on TypeAbsence {
  String get value {
    switch (this) {
      case TypeAbsence.absent:
        return 'Absent';
      case TypeAbsence.retard:
        return 'Retard';
    }
  }

  static TypeAbsence fromString(String str) {
    switch (str.toLowerCase()) {
      case 'absent':
        return TypeAbsence.absent;
      case 'retard':
        return TypeAbsence.retard;
      default:
        throw ArgumentError('Valeur inconnue pour TypeAbsence: $str');
    }
  }
}
