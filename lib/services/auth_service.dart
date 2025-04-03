import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Récupérer l'utilisateur connecté
  static User? get currentUser => _auth.currentUser;

  // 🔹 Inscription
  static Future<UserCredential?> registerWithEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("✅ Inscription réussie : ${credential.user?.uid}");
      return credential;
    } on FirebaseAuthException catch (e) {
      log("❌ Erreur d'inscription : ${e.message}");
      rethrow;
    }
  }

  // 🔹 Connexion
  static Future<UserCredential?> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("✅ Connexion réussie : ${credential.user?.uid}");
      return credential;
    } on FirebaseAuthException catch (e) {
      log("❌ Erreur de connexion : ${e.message}");
      rethrow;
    }
  }

  // 🔹 Déconnexion
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      log("✅ Déconnexion réussie");
    } catch (e) {
      log("❌ Erreur de déconnexion : $e");
    }
  }
}
