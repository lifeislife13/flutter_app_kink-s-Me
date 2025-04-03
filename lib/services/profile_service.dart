import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance;

  /// Uploader une image de profil et renvoyer son URL
  static Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("Utilisateur non connecté");

      final ref = _storage.ref().child('profilePics/$uid.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Erreur upload image: $e");
      return null;
    }
  }

  /// Sauvegarder ou mettre à jour un profil utilisateur dans Firestore
  static Future<void> saveProfile({
    required String bio,
    required List<String> preferences,
    required String orientation,
    String? imageUrl,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("Utilisateur non connecté");

    final data = {
      "bio": bio,
      "preferences": preferences,
      "orientation": orientation,
      "updatedAt": FieldValue.serverTimestamp(),
    };

    if (imageUrl != null) {
      data["profileImageUrl"] = imageUrl;
    }

    await _firestore
        .collection("users")
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  /// Récupérer les infos de profil depuis Firestore
  static Future<Map<String, dynamic>?> fetchProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection("users").doc(uid).get();
    return doc.data();
  }
}
