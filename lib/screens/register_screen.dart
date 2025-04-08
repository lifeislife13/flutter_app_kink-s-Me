import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kinksme/screens/presentation_screen.dart';
import 'dart:developer' as dev;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  String errorMessage = '';
  int selectedRole = -1;
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  final Color deepRed = const Color.fromARGB(255, 152, 5, 5);

  String selectedGenre = '';

  Future<void> _handleRegister() async {
    setState(() => errorMessage = '');

    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      setState(() => errorMessage = "Tous les champs sont obligatoires.");
      return;
    }

    if (pass != confirm) {
      setState(() => errorMessage = "Les mots de passe ne correspondent pas.");
      return;
    }

    if (selectedRole == -1) {
      setState(() => errorMessage = "Veuillez choisir un rôle.");
      return;
    }

    if (selectedGenre.isEmpty) {
      setState(() => errorMessage = "Veuillez indiquer votre genre.");
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
      final uid = userCredential.user?.uid;

      // ✅ Envoi de l'e-mail de vérification
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "📧 Un email de vérification a été envoyé. Vérifiez votre boîte mail.",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5),
            ),
          );
        }
      }

      if (uid != null) {
        final userDoc = {
          'email': email,
          'role': selectedRole,
          'genre': selectedGenre,
          'createdAt': FieldValue.serverTimestamp(),
        };

        if (selectedGenre.toLowerCase() == "femme") {
          userDoc['isPremium'] = true;
          userDoc['premiumUntil'] = Timestamp.fromDate(
            DateTime.now().add(const Duration(days: 7)),
          );
        } else {
          userDoc['isPremium'] = false;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(userDoc);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('seenPresentation', true);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PresentationScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message ?? "Erreur inconnue.");
      dev.log("Firebase Auth Error: ${e.message}", name: "Register");
    } catch (e) {
      setState(() => errorMessage = "Erreur inattendue.");
      dev.log("Erreur: $e", name: "Register");
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    bool isConfirm = label.toLowerCase().contains("confirmer");
    bool obscure = isConfirm ? _obscureConfirm : _obscurePass;

    return TextField(
      controller: controller,
      obscureText: isPassword ? obscure : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    if (isConfirm) {
                      _obscureConfirm = !_obscureConfirm;
                    } else {
                      _obscurePass = !_obscurePass;
                    }
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoleOption("assets/dominant.png", "Dominant", 0),
        const SizedBox(width: 20),
        _buildRoleOption("assets/soumis.png", "Soumis", 1),
        const SizedBox(width: 20),
        _buildRoleOption("assets/switch.png", "Switch", 2),
      ],
    );
  }

  Widget _buildRoleOption(String img, String label, int value) {
    bool isSelected = selectedRole == value;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = value),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              border: Border.all(
                  color: isSelected ? deepRed : Colors.white, width: 3),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: TextStyle(color: isSelected ? deepRed : Colors.white)),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return DropdownButtonFormField<String>(
      value: selectedGenre.isEmpty ? null : selectedGenre,
      dropdownColor: Colors.black,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "Genre",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: const [
        DropdownMenuItem(value: "femme", child: Text("Femme")),
        DropdownMenuItem(value: "homme", child: Text("Homme")),
        DropdownMenuItem(value: "non-binaire", child: Text("Non-binaire")),
        DropdownMenuItem(value: "autre", child: Text("Autre")),
      ],
      onChanged: (value) => setState(() => selectedGenre = value ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/inscription.png", fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  const Text(
                    "Rejoignez-nous",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField("Email", _emailCtrl),
                  const SizedBox(height: 15),
                  _buildTextField("Mot de passe", _passCtrl, isPassword: true),
                  const SizedBox(height: 15),
                  _buildTextField("Confirmer le mot de passe", _confirmCtrl,
                      isPassword: true),
                  const SizedBox(height: 20),
                  _buildGenderSelector(),
                  const SizedBox(height: 20),
                  _buildRoleSelector(),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deepRed,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("S'inscrire",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  if (errorMessage.isNotEmpty)
                    Text(errorMessage,
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  const Text("Kink’s Me",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
