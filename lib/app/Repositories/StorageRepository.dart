import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<String?> uploadImageAndGetUrl(File imageFile) async {
    try {
      print("🔵 Début de l'upload avec fichier: ${imageFile.path}");

      // Vérifier si le fichier existe
      if (!await imageFile.exists()) {
        print("❌ Le fichier n'existe pas: ${imageFile.path}");
        return null;
      }

      print("✅ Fichier existe, taille: ${await imageFile.length()} bytes");

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      print("🔵 Nom du fichier: $fileName.jpg");

      final ref = FirebaseStorage.instance.ref().child('images/$fileName.jpg');
      print("🔵 Référence Firebase: ${ref.fullPath}");

      // Upload avec monitoring
      UploadTask uploadTask = ref.putFile(imageFile);

      // Écouter le progrès
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        print("📤 Progrès upload: ${progress.toStringAsFixed(2)}%");
      });

      // Attendre la fin de l'upload
      TaskSnapshot taskSnapshot = await uploadTask;
      print("✅ Upload terminé! État: ${taskSnapshot.state}");

      // Récupérer l'URL
      String downloadUrl = await ref.getDownloadURL();
      print("✅ URL de téléchargement: $downloadUrl");

      return downloadUrl;
    } catch (e, stackTrace) {
      print("❌ Erreur complète: $e");
      print("📋 Stack trace: $stackTrace");
      return null;
    }
  }
}
