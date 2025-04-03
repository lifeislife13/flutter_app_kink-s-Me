import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Conditions d'utilisation"), backgroundColor: Colors.red),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Voici les Conditions Générales d'Utilisation de Kink's Me...\n\n"
          "1. Votre vie privée est protégée...\n"
          "2. L'application respecte les lois sur la protection des données...\n"
          "3. Vous pouvez supprimer votre compte et vos données à tout moment...\n"
          "4. L'utilisation de la géolocalisation est soumise à votre consentement...",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
