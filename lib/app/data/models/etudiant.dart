class Etudiant {
  final String matricule;
  final String prenom;
  final String nom;
  

  Etudiant({
    required this.matricule,
    required this.prenom,
    required this.nom,
  });
}


List<Etudiant> mockEtudiants = [
  Etudiant(matricule: 'ISM2023DK001', prenom: 'Fatou', nom: 'Diop'),
  Etudiant(matricule: 'ISM2023DK002', prenom: 'Mamadou', nom: 'Diallo'),
  Etudiant(matricule: 'ISM2023DK003', prenom: 'Aissata', nom: 'Barry'),
  Etudiant(matricule: 'ISM2023DK004', prenom: 'Seydou', nom: 'Gueye'),
  Etudiant(matricule: 'ISM2023DK005', prenom: 'Khady', nom: 'Sow'),
  Etudiant(matricule: 'ISM2023DK006', prenom: 'Lamine', nom: 'Ndoye'),
  Etudiant(matricule: 'ISM2023DK007', prenom: 'Mariama', nom: 'Traoré'),
  Etudiant(matricule: 'ISM2023DK008', prenom: 'Cheikh', nom: 'Fall'),
  Etudiant(matricule: 'ISM2023DK009', prenom: 'Ndeye', nom: 'Thiam'),
  Etudiant(matricule: 'ISM2023DK010', prenom: 'Pape', nom: 'Diagne'),
]; 