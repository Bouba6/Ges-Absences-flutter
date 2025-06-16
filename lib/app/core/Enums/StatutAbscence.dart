enum StatutAbsence { justifier, nonJustifier }

extension StatutAbsenceExtension on StatutAbsence {
  String get value {
    switch (this) {
      case StatutAbsence.justifier:
        return 'JUSTIFIER';
      case StatutAbsence.nonJustifier:
        return 'NON_JUSTIFIER';
    }
  }

  static StatutAbsence fromString(String str) {
    switch (str.toUpperCase()) {
      case 'JUSTIFIER':
        return StatutAbsence.justifier;
      case 'NON_JUSTIFIER':
        return StatutAbsence.nonJustifier;
      default:
        throw ArgumentError('Valeur inconnue pour StatutAbsence: $str');
    }
  }
}
