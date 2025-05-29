import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class JustificationAbsence extends StatefulWidget {
  const JustificationAbsence({Key? key}) : super(key: key);

  @override
  State<JustificationAbsence> createState() => _JustificationAbsenceState();
}

class _JustificationAbsenceState extends State<JustificationAbsence> {
  String? selectedType;
  TextEditingController descriptionController = TextEditingController();
  PlatformFile? selectedFile;

  void _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  void _submitJustification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text('Votre justification a été envoyée avec succès.'),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: const Text('Fermer'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aminata Diop', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('MBA 2 - Finance'),
                      Text('ID: ISM2023FD001')
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.logout),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text('Justifier une absence', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              const Text('Cours concerné'),
              const Text('12/05/25 - Comptabilité', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Type de justification'),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedType,
                hint: const Text('Sélectionner un type'),
                items: [
                  'Maladie',
                  'Retard de transport',
                  'Rendez-vous officiel',
                  'Autre'
                ].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (value) => setState(() => selectedType = value),
              ),
              const SizedBox(height: 20),
              const Text('Description'),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Joindre un document'),
              GestureDetector(
                onTap: _pickDocument,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    selectedFile != null ? selectedFile!.name : 'Glissez-déposez un fichier ou cliquez pour sélectionner',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: _submitJustification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB86B1D),
                    ),
                    child: const Text('Envoyer'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
