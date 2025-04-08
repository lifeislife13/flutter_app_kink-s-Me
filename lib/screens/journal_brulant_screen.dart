import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinksme/models/message_style.dart';
import 'package:kinksme/widgets/personnalisation_dialog.dart';

class JournalBrulantScreen extends StatefulWidget {
  const JournalBrulantScreen({super.key});

  @override
  State<JournalBrulantScreen> createState() => _JournalBrulantScreenState();
}

class _JournalBrulantScreenState extends State<JournalBrulantScreen> {
  final TextEditingController _controller = TextEditingController();

  MessageStyle selectedStyle = MessageStyle.voileDeSoie;
  String customSignature = "Votre signature ici...";
  String? manualSignatureBase64;

  bool isPremium = false;
  bool autoPublish = false;

  @override
  void initState() {
    super.initState();
    _checkPremiumStatus();
    _checkAutoPublishStatus();
  }

  Future<void> _checkPremiumStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists && doc.data()!.containsKey('isPremium')) {
      setState(() {
        isPremium = doc['isPremium'] == true;
      });
    }

    setState(() {});
  }

  Future<void> _checkAutoPublishStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists && doc.data()!.containsKey('autoPublish')) {
      setState(() {
        autoPublish = doc['autoPublish'] == true;
      });
    }
  }

  Future<void> _saveJournalToFirestore() async {
    final journalText = _controller.text.trim();
    if (journalText.isEmpty) {
      _showSnackbar("Le journal est vide");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackbar("Vous devez être connecté pour sauvegarder");
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

      _showSnackbar("Journal sauvegardé 🔥");
    } catch (e) {
      print("Erreur journal -> $e");
      _showSnackbar("Erreur de sauvegarde");
    }
  }

  Future<void> _openPlumeSecrete() async {
    final journalText = _controller.text.trim();
    if (journalText.isEmpty) {
      _showSnackbar("Veuillez écrire dans le journal");
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

  Future<void> _goToMiseEnBeaute() async {
    final journalText = _controller.text.trim();
    if (journalText.isEmpty) {
      _showSnackbar("Veuillez écrire dans le journal");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (autoPublish) {
      await FirebaseFirestore.instance.collection('boudoirEcrits').add({
        'title': journalText.split('\n').first,
        'text': journalText,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'style': selectedStyle.toString(),
        'signature': customSignature,
        'manualSignatureBase64': manualSignatureBase64,
        'font': 'Georgia',
        'isValidated': true,
      });

      _showSnackbar("Publié dans le Boudoir ✨");

      Navigator.pushNamed(context, '/boudoir', arguments: {
        'initialTab': 'communautaire',
      });
    } else {
      Navigator.pushNamed(context, '/boudoirEditor', arguments: {
        'text': journalText,
        'signature': customSignature,
        'style': selectedStyle.toString(),
        'manualSignatureBase64': manualSignatureBase64,
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openPersonnalisationDialog() {
    showDialog(
      context: context,
      builder: (_) => PersonnalisationDialog(
        isPremium: isPremium,
        initialStyle: selectedStyle,
        initialSignature: customSignature,
        initialManualSignatureBase64: manualSignatureBase64,
        onConfirmed: (signatureText, style, signatureImage) {
          setState(() {
            customSignature = signatureText;
            selectedStyle = style;
            manualSignatureBase64 = signatureImage;
          });
        },
      ),
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
            onPressed: _openPersonnalisationDialog,
            icon: const Icon(Icons.palette, color: Colors.redAccent),
            tooltip: "🎨 Personnaliser",
          ),
          IconButton(
            onPressed: _saveJournalToFirestore,
            icon: const Icon(Icons.cloud_upload, color: Colors.redAccent),
            tooltip: "Sauvegarder",
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(selectedStyle.assetPath, fit: BoxFit.cover),
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
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Écris ici ton journal brûlant...",
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black54,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.black87,
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBottomButton("Plume Secrète", _openPlumeSecrete),
                    _buildBottomButton("Mise en beauté ✨", _goToMiseEnBeaute),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
