import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinksme/screens/presentation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int selectedRole = -1;
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  // Les booléens pour masquer/afficher les mots de passe
  bool _obscurePass = true; // pour le champ “Mot de passe”
  bool _obscureConfirm = true; // pour le champ “Confirmer le mot de passe”

  String errorMessage = '';
  final Color deepRed = const Color.fromARGB(255, 152, 5, 5);

  // Méthode d’inscription
  Future<void> _handleRegister() async {
    setState(() => errorMessage = '');
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirm = _confirmCtrl.text;

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      setState(() => errorMessage = "Tous les champs sont obligatoires.");
      return;
    }

    if (pass != confirm) {
      setState(() => errorMessage = "Les mots de passe ne correspondent pas.");
      return;
    }

    if (selectedRole < 0 || selectedRole > 2) {
      setState(() => errorMessage = "Veuillez sélectionner un rôle.");
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
      final uid = userCredential.user?.uid;

      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': email,
          'role': selectedRole,
          'createdAt': FieldValue.serverTimestamp(),
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('seenPresentation', true);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PresentationScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message ?? "Erreur inconnue.");
      dev.log("Firebase Auth Error: ${e.message}", name: "Register");
    } catch (e) {
      setState(() => errorMessage = "Erreur inattendue. Veuillez réessayer.");
      dev.log("Unknown error: $e", name: "Register");
    }
  }

  Widget _buildRoleButton({
    required String imagePath,
    required String label,
    required int roleValue,
  }) {
    bool isSelected = (selectedRole == roleValue);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = roleValue;
        });
      },
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? deepRed : Colors.white,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? deepRed : Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // --- CORRECTION : on utilise _obscurePass / _obscureConfirm ---
  Widget _buildTextField(String hint, {bool isPassword = false}) {
    late TextEditingController controller;
    if (hint.contains("Email")) {
      controller = _emailCtrl;
    } else if (hint.contains("Confirmer")) {
      controller = _confirmCtrl;
    } else {
      controller = _passCtrl;
    }

    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        // On choisit la bonne variable pour "obscureText"
        obscureText:
            isPassword
                ? (hint.contains("Confirmer") ? _obscureConfirm : _obscurePass)
                : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.black.withOpacity(0.6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      (hint.contains("Confirmer")
                              ? _obscureConfirm
                              : _obscurePass)
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        if (hint.contains("Confirmer")) {
                          _obscureConfirm = !_obscureConfirm;
                        } else {
                          _obscurePass = !_obscurePass;
                        }
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }
  // --- FIN CORRECTION ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/inscription.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  const Text(
                    "Rejoignez-nous",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField("Email"),
                  const SizedBox(height: 15),
                  _buildTextField("Mot de passe", isPassword: true),
                  const SizedBox(height: 15),
                  _buildTextField(
                    "Confirmer le mot de passe",
                    isPassword: true,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRoleButton(
                        imagePath: "assets/dominant.png",
                        label: "Dominant",
                        roleValue: 0,
                      ),
                      const SizedBox(width: 20),
                      _buildRoleButton(
                        imagePath: "assets/soumis.png",
                        label: "Soumis",
                        roleValue: 1,
                      ),
                      const SizedBox(width: 20),
                      _buildRoleButton(
                        imagePath: "assets/switch.png",
                        label: "Switch",
                        roleValue: 2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deepRed,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "S'inscrire",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 90, 90),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 40),
                  const Text(
                    "Kink’s Me",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 142, 6, 6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
