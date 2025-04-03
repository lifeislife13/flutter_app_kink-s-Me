import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinksme/models/message_style.dart';

class JournalBrulantScreen extends StatefulWidget {
  const JournalBrulantScreen({super.key});

  @override
  State<JournalBrulantScreen> createState() => _JournalBrulantScreenState();
}

class _JournalBrulantScreenState extends State<JournalBrulantScreen> {
  final TextEditingController _controller = TextEditingController();

  // On garde un style par défaut (plus de personnalisation).
  MessageStyle selectedStyle = MessageStyle.voileDeSoie;

  // Signature “par défaut”
  String customSignature = "Votre signature ici...";
  String? manualSignatureBase64;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Sauvegarde le texte sans le publier
  Future<void> _saveJournalToFirestore() async {
    final journalText = _controller.text.trim();
    if (journalText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Le journal est vide")));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vous devez être connecté pour sauvegarder"),
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('journalBrulant').add({
        'text': journalText,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'style': selectedStyle.toString(),
        'signature': customSignature,
        'manualSignatureBase64': manualSignatureBase64,
        'isPublished': false,
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Journal sauvegardé")));
    } catch (e) {
      print("Erreur journal -> $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erreur de sauvegarde")));
    }
  }

  /// Publication dans le Boudoir + navigation auto vers l’onglet Communauté
  Future<void> _publishToBoudoir() async {
    final journalText = _controller.text.trim();
    if (journalText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez écrire dans le journal")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vous devez être connecté pour publier")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('boudoirEcrits').add({
        'text': journalText,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'style': selectedStyle.toString(),
        'signature': customSignature,
        'manualSignatureBase64': manualSignatureBase64,
        // isPublished = true ou non ?
        // (Selon ta logique, tu peux l'ajouter si nécessaire)
      });

      // --- NAVIGATION vers Boudoir, onglet “Communauté” ---
      Navigator.pushNamed(
        context,
        '/boudoir',
        arguments: {'initialTab': 'communautaire'},
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Publié dans le Boudoir")));
    } catch (e) {
      print("Erreur publication -> $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la publication")),
      );
    }
  }

  /// Ouvrir l’écran Plume Secrète (si tu souhaites garder cette fonctionnalité)
  void _openPlumeSecrete() {
    final journalText = _controller.text.trim();
    if (journalText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez écrire dans le journal")),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      '/plumeSecrete',
      arguments: {
        'text': journalText,
        'signature': customSignature,
        'style': selectedStyle.toString(),
        'manualSignatureBase64': manualSignatureBase64,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal Brûlant"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _saveJournalToFirestore,
            icon: const Icon(Icons.cloud_upload),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/fondjournal.png", fit: BoxFit.cover),
          ),
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Écris ici ton journal brûlant...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.black54,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Personnalisation supprimée :
                    // ElevatedButton(
                    //   onPressed: _openCustomizationDialog,
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.red,
                    //   ),
                    //   child: const Text("Personnaliser"),
                    // ),
                    ElevatedButton(
                      onPressed: _openPlumeSecrete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Plume Secrète"),
                    ),
                    ElevatedButton(
                      onPressed: _publishToBoudoir,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Publier"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
