import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

class SupabaseStorageService {
  static const String bucketName = 'images';
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Upload une image et retourne l'URL publique
  Future<String?> uploadImageAndGetUrl(File imageFile) async {
    try {
      // Générer un nom de fichier unique
      final fileName = _generateUniqueFileName(imageFile);

      // Déterminer le type MIME
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

      // Upload le fichier
      final response = await _supabase.storage
          .from(bucketName)
          .upload(
            fileName,
            imageFile,
            fileOptions: FileOptions(
              contentType: mimeType,
              upsert: false, // Ne pas écraser si le fichier existe
            ),
          );

      // Obtenir l'URL publique
      final publicUrl = _supabase.storage
          .from(bucketName)
          .getPublicUrl(fileName);

      return publicUrl;
    } on StorageException catch (e) {
      print('Erreur Supabase Storage: ${e.message}');
      throw Exception('Erreur lors de l\'upload: ${e.message}');
    } catch (e) {
      print('Erreur générale: $e');
      throw Exception('Erreur lors de l\'upload: $e');
    }
  }

  /// Upload multiple images
  Future<List<String>> uploadMultipleImages(List<File> imageFiles) async {
    final List<String> urls = [];

    for (final file in imageFiles) {
      final url = await uploadImageAndGetUrl(file);
      if (url != null) {
        urls.add(url);
      }
    }

    return urls;
  }

  /// Supprimer une image
  Future<bool> deleteImage(String fileName) async {
    try {
      await _supabase.storage.from(bucketName).remove([fileName]);
      return true;
    } catch (e) {
      print('Erreur lors de la suppression: $e');
      return false;
    }
  }

  /// Extraire le nom du fichier depuis une URL
  String getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    return path.basename(uri.path);
  }

  /// Générer un nom de fichier unique
  String _generateUniqueFileName(File file) {
    final extension = path.extension(file.path);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomString = _generateRandomString(8);
    return 'justificatif_${timestamp}_$randomString$extension';
  }

  /// Générer une chaîne aléatoire
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(
      length,
      (index) => chars[random % chars.length],
    ).join();
  }

  /// Vérifier si un fichier existe
  Future<bool> fileExists(String fileName) async {
    try {
      final response = await _supabase.storage
          .from(bucketName)
          .list(searchOptions: SearchOptions(search: fileName, limit: 1));

      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Obtenir les métadonnées d'un fichier
  Future<FileObject?> getFileMetadata(String fileName) async {
    try {
      final response = await _supabase.storage
          .from(bucketName)
          .list(searchOptions: SearchOptions(search: fileName, limit: 1));

      if (response.isNotEmpty) {
        return response.first; // Return the FileObject directly
      }
      return null;
    } catch (e) {
      print('Erreur métadonnées: $e');
      return null;
    }
  }
}
