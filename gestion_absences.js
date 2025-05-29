use('gestion_absences');

// Nettoyage complet pour éviter doublons
db.users.deleteMany({});
db.etudiants.deleteMany({});
db.absences.deleteMany({});
db.retards.deleteMany({});
db.justifications.deleteMany({});
db.pointages.deleteMany({});

// --- COLLECTION users ---
db.users.insertMany([
  {
    matricule: "ADM001",
    nom: "Fall",
    prenom: "Mamadou",
    role: "admin",
    email: "mamadou.fall@ism.edu.sn",
    password: "hashed_password_admin",
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    matricule: "PROF001",
    nom: "Ndoye",
    prenom: "Fatou",
    role: "professeur",
    email: "fatou.ndoye@ism.edu.sn",
    password: "hashed_password_prof",
    created_at: new Date(),
    updated_at: new Date()
  },
  {
    matricule: "ETU001",
    nom: "Diop",
    prenom: "Aminata",
    role: "etudiant",
    email: "aminata.diop@ism.edu.sn",
    password: "hashed_password_etu",
    created_at: new Date(),
    updated_at: new Date()
  }
]);

db.users.createIndex({ matricule: 1 }, { unique: true });
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ role: 1 });

// --- COLLECTION etudiants ---
db.etudiants.insertOne({
  matricule: "ETU001",
  nom: "Diop",
  prenom: "Aminata",
  classe: "MBA 2 - Finance",
  email: "aminata.diop@ism.edu.sn",
  telephone: "770000000",
  created_at: new Date(),
  updated_at: new Date()
});

db.etudiants.createIndex({ matricule: 1 }, { unique: true });
db.etudiants.createIndex({ classe: 1 });

// --- COLLECTION absences ---
const etudiantId = db.etudiants.findOne({ matricule: "ETU001" })._id;

db.absences.insertOne({
  etudiant_id: etudiantId,
  date: new Date("2024-03-01T08:00:00Z"),
  motif: "Maladie",
  status: "non_justifie",
  created_at: new Date(),
  updated_at: new Date()
});

db.absences.createIndex({ etudiant_id: 1, date: -1 });
db.absences.createIndex({ status: 1 });

// --- COLLECTION retards ---
db.retards.insertOne({
  etudiant_id: etudiantId,
  date: new Date("2024-03-02T08:05:00Z"),
  duree_min: 10,
  motif: "Transport",
  status: "justifie",
  created_at: new Date(),
  updated_at: new Date()
});

db.retards.createIndex({ etudiant_id: 1, date: -1 });
db.retards.createIndex({ status: 1 });

// --- COLLECTION justifications ---
const absenceId = db.absences.findOne({ etudiant_id: etudiantId })._id;

db.justifications.insertOne({
  absence_id: absenceId,
  etudiant_id: etudiantId,
  document: "https://exemple.com/justificatif_maladie.pdf",
  description: "Consultation médicale",
  date_soumission: new Date(),
  status: "en_attente",
  traite_par: null,
  commentaire: "",
  created_at: new Date(),
  updated_at: new Date()
});

db.justifications.createIndex({ absence_id: 1 }, { unique: true });
db.justifications.createIndex({ etudiant_id: 1, date_soumission: -1 });
db.justifications.createIndex({ status: 1 });

// --- COLLECTION pointages ---
db.pointages.insertOne({
  etudiant_id: etudiantId,
  date: new Date("2024-03-01T08:00:00Z"),
  type: "entrée",
  created_at: new Date(),
  updated_at: new Date()
});

db.pointages.createIndex({ etudiant_id: 1, date: -1 });
db.pointages.createIndex({ type: 1 });

print("✅ Collections créées et documents insérés avec succès !");
