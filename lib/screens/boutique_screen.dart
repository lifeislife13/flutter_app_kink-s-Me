import 'package:flutter/material.dart';

class BoutiqueScreen extends StatefulWidget {
  const BoutiqueScreen({super.key});

  @override
  State<BoutiqueScreen> createState() => _BoutiqueScreenState();
}

class _BoutiqueScreenState extends State<BoutiqueScreen> {
  void _onSavePressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sauvegarde effectuée depuis la boutique")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("La Forge des Plaisirs"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Sauvegarder",
            onPressed: _onSavePressed,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondforge.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Text(
            "la Forge des Plaisirs",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
