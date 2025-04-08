import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BoudoirEditorScreen extends StatefulWidget {
  const BoudoirEditorScreen({super.key});

  @override
  State<BoudoirEditorScreen> createState() => _BoudoirEditorScreenState();
}

class _BoudoirEditorScreenState extends State<BoudoirEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? signature;
  String? style;
  String? manualSignature;
  String _selectedFont = 'Georgia';

  final List<String> _fonts = [
    'Georgia',
    'Times New Roman',
    'Courier New',
    'DancingScript',
    'AmaticSC',
    'GreatVibes',
    'Pacifico',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    signature = args['signature'];
    style = args['style'];
    manualSignature = args['manualSignatureBase64'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('boudoirEcrits').add({
      'title': _titleController.text.trim(),
      'text': _contentController.text.trim(),
      'userId': uid,
      'timestamp': FieldValue.serverTimestamp(),
      'style': style,
      'signature': signature,
      'manualSignatureBase64': manualSignature,
      'font': _selectedFont,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Publication envoyée au Boudoir")),
    );

    Navigator.pushNamed(context, '/boudoir', arguments: {
      'initialTab': 'communautaire',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mise en beauté ✨"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/veloursnoir.png", fit: BoxFit.cover),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: const InputDecoration(
                    labelText: "Titre de votre écrit",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: _selectedFont,
                  isExpanded: true,
                  items: _fonts.map((font) {
                    return DropdownMenuItem(
                      value: font,
                      child: Text(font,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFont = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    expands: true,
                    style: TextStyle(
                      fontFamily: _selectedFont,
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.6,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Écrivez ici votre texte sensuel...",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _publish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "✨ Publier dans le Boudoir ✨",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
