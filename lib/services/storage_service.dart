import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a visitor's photo to Firebase Storage and returns the download URL.
  Future<String?> uploadVisitorPhoto(File imageFile, String visitorId) async {
    try {
      final String fileName = 'visitor_photos/$visitorId${path.extension(imageFile.path)}';
      final Reference ref = _storage.ref().child(fileName);
      
      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading photo: $e');
      return null;
    }
  }
}
