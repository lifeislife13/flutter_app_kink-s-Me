import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Enregistrer ou mettre à jour le profil utilisateur
  Future<void> saveUserProfile({
    required String username,
    required String email,
    required String role, // Dominant/Soumis/etc.
    required String bio,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Utilisateur non authentifié");

    await _db.collection('users').doc(user.uid).set({
      'username': username,
      'email': email,
      'role': role,
      'bio': bio,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // merge garde les anciens champs
  }

  // Récupérer le profil utilisateur
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    return doc.exists ? doc.data() : null;
  }
}
