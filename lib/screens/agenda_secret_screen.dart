import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgendaSecretScreen extends StatefulWidget {
  const AgendaSecretScreen({super.key});

  @override
  State<AgendaSecretScreen> createState() => _AgendaSecretScreenState();
}

class _AgendaSecretScreenState extends State<AgendaSecretScreen> {
  final List<_RendezVous> _rendezvous = [];
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _buddyCtrl = TextEditingController();
  final TextEditingController _safewordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _buddyCtrl.dispose();
    _safewordCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchEvents() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('agenda')
              .where('userId', isEqualTo: uid)
              .get();
      setState(() {
        _rendezvous.clear();
        _rendezvous.addAll(
          snapshot.docs.map(
            (doc) => _RendezVous(
              title: doc['title'],
              buddy: doc['buddy'],
              safeword: doc['safeword'],
              date: DateTime.parse(doc['date']),
            ),
          ),
        );
      });
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.black87,
            title: const Text(
              "Nouveau Rendez-Vous",
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _titleCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Titre",
                      labelStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                  TextField(
                    controller: _buddyCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Buddy virtuel (contact d’urgence)",
                      labelStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                  TextField(
                    controller: _safewordCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Safeword",
                      labelStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  "Annuler",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                onPressed: _addEvent,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Ajouter"),
              ),
            ],
          ),
    );
  }

  Future<void> _addEvent() async {
    final title = _titleCtrl.text.trim();
    final buddy = _buddyCtrl.text.trim();
    final sw = _safewordCtrl.text.trim();
    if (title.isNotEmpty && buddy.isNotEmpty && sw.isNotEmpty) {
      final newRdv = _RendezVous(
        title: title,
        buddy: buddy,
        safeword: sw,
        date: DateTime.now().add(const Duration(days: 1)),
      );
      setState(() => _rendezvous.add(newRdv));
      _titleCtrl.clear();
      _buddyCtrl.clear();
      _safewordCtrl.clear();
      Navigator.pop(context);

      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
      try {
        await FirebaseFirestore.instance.collection('agenda').add({
          'title': newRdv.title,
          'buddy': newRdv.buddy,
          'safeword': newRdv.safeword,
          'date': newRdv.date.toIso8601String(),
          'userId': uid,
        });
      } catch (e) {
        debugPrint("Erreur lors de l'enregistrement de l'agenda : \$e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda Secret"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: _showAddDialog, icon: const Icon(Icons.add)),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondagenda.png"),
            fit: BoxFit.cover,
          ),
        ),
        child:
            _rendezvous.isEmpty
                ? const Center(
                  child: Text(
                    "Aucun rendez-vous planifié.",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                : ListView.builder(
                  itemCount: _rendezvous.length,
                  itemBuilder: (ctx, i) {
                    final rdv = _rendezvous[i];
                    return ListTile(
                      title: Text(
                        rdv.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Buddy: \${rdv.buddy} | Safeword: \${rdv.safeword}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Text(
                        "\${rdv.date.day}/\${rdv.date.month}/\${rdv.date.year}",
                        style: const TextStyle(color: Colors.white54),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}

class _RendezVous {
  final String title;
  final String buddy;
  final String safeword;
  final DateTime date;

  _RendezVous({
    required this.title,
    required this.buddy,
    required this.safeword,
    required this.date,
  });
}
