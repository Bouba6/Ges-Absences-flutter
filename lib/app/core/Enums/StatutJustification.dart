enum StatutJustification { valide, enAttente, rejete }

extension StatutJustificationExtension on StatutJustification {
  String get value {
    switch (this) {
      case StatutJustification.valide:
        return 'VALIDE';
      case StatutJustification.enAttente:
        return 'EN_ATTENTE';
      case StatutJustification.rejete:
        return 'REJETEE';
    }
  }

  static StatutJustification fromString(String str) {
    switch (str.toUpperCase()) {
      case 'VALIDE':
        return StatutJustification.valide;
      case 'EN_ATTENTE':
        return StatutJustification.enAttente;
      case 'REJETEE':
        return StatutJustification.rejete;
      default:
        throw ArgumentError('Valeur inconnue pour StatutJustification: $str');
    }
  }
}
