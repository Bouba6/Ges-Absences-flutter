import 'package:flutter/material.dart';

class AssiduiteView extends StatelessWidget {
  const AssiduiteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person, size: 28),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Aminata Diop', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('MBA 2 - Finance', style: TextStyle(fontSize: 13)),
                          Text('ID: ISM2023FDO01', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Placeholder(), // Remplacer par un widget QR code réel si besoin
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Historique d'assiduité",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: const [
                    _AssiduiteRow(
                      matiere: 'Comptabilité Avancée',
                      date: "Aujourd'hui - 08:15",
                      statut: 'Non justifié',
                      isJustifie: false,
                    ),
                    _AssiduiteRow(
                      matiere: 'Gestion de Portefeuille',
                      date: 'Hier - 08:15',
                      statut: 'Non justifié',
                      isJustifie: false,
                    ),
                    _AssiduiteRow(
                      matiere: 'Économétrie Financière',
                      date: '12/05/25 - 08:15',
                      statut: 'Justifiée',
                      isJustifie: true,
                    ),
                    _AssiduiteRow(
                      matiere: 'Comptabilité Avancée',
                      date: '12/05/25 - 08:15',
                      statut: 'Justifiée',
                      isJustifie: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA86A1D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Voir plus'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssiduiteRow extends StatelessWidget {
  final String matiere;
  final String date;
  final String statut;
  final bool isJustifie;
  const _AssiduiteRow({
    required this.matiere,
    required this.date,
    required this.statut,
    required this.isJustifie,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(matiere, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          isJustifie
              ? Text(
                  statut,
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                )
              : Row(
                  children: [
                    Text(
                      statut,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA86A1D),
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Justifier', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
} 