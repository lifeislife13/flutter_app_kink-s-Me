import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KinkEleganceScreen extends StatefulWidget {
  const KinkEleganceScreen({super.key});

  @override
  State<KinkEleganceScreen> createState() => _KinkEleganceScreenState();
}

class _KinkEleganceScreenState extends State<KinkEleganceScreen> {
  late Future<List<Map<String, dynamic>>> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _createContactIfNeeded();
    _contactsFuture = _fetchContacts();
  }

  Future<void> _createContactIfNeeded() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('kinkEleganceContacts')
            .doc(uid)
            .get();

    if (!doc.exists) {
      await FirebaseFirestore.instance
          .collection('kinkEleganceContacts')
          .doc(uid)
          .set({'username': 'Nouvel utilisateur', 'status': 'Actif'});
    }
  }

  Future<List<Map<String, dynamic>>> _fetchContacts() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('kinkEleganceContacts')
            .get();
    return snapshot.docs
        .map((doc) {
          final raw = doc.data();
          return {'id': doc.id, ...raw};
        })
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Kink Élégance"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _contactsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Aucun contact Kink Élégance pour le moment.",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          final contacts = snapshot.data!;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                title: Text(
                  contact['username'] ?? 'Utilisateur inconnu',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  contact['status'] ?? '',
                  style: const TextStyle(color: Colors.white60),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
