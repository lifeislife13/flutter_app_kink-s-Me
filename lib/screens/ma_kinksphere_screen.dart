// ✅ Fichier corrigé : ma_kinksphere_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinksme/models/kink_contact.dart';

class MaKinksphereScreen extends StatefulWidget {
  const MaKinksphereScreen({super.key});

  @override
  State<MaKinksphereScreen> createState() => _MaKinksphereScreenState();
}

class _MaKinksphereScreenState extends State<MaKinksphereScreen> {
  final CollectionReference _contactsCollection = FirebaseFirestore.instance
      .collection('kinksphereContacts');
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _addContactDialog() async {
    final usernameCtrl = TextEditingController();
    final statusCtrl = TextEditingController(text: "En attente d’inspiration");
    bool restricted = false;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            return AlertDialog(
              title: const Text("Ajouter un contact"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: usernameCtrl,
                      decoration: const InputDecoration(labelText: "Pseudo"),
                    ),
                    TextField(
                      controller: statusCtrl,
                      decoration: const InputDecoration(labelText: "Statut"),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text("Visibilité restreinte ?"),
                        Switch(
                          value: restricted,
                          onChanged: (val) {
                            setStateDialog(() {
                              restricted = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = usernameCtrl.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Veuillez saisir un pseudo"),
                        ),
                      );
                      return;
                    }
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Vous devez être connecté pour ajouter un contact",
                          ),
                        ),
                      );
                      Navigator.pop(ctx);
                      return;
                    }
                    try {
                      await _contactsCollection.add({
                        'username': name,
                        'status': statusCtrl.text.trim(),
                        'isBlocked': false,
                        'isVisibilityRestricted': restricted,
                        'privateNotes': '',
                        'userId': user.uid,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Contact ajouté")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
                    }
                    Navigator.pop(ctx);
                  },
                  child: const Text("Ajouter"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showContactMenu(KinkContact contact) async {
    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_off),
                title: Text(contact.isBlocked ? "Débloquer" : "Bloquer"),
                onTap: () {
                  Navigator.pop(ctx);
                  _updateContactField(contact, 'isBlocked', !contact.isBlocked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text("Signaler"),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${contact.username} signalé.")),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_note),
                title: const Text("Notes privées"),
                onTap: () {
                  Navigator.pop(ctx);
                  _editPrivateNote(contact);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Supprimer"),
                onTap: () {
                  Navigator.pop(ctx);
                  _deleteContact(contact.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editPrivateNote(KinkContact contact) async {
    final noteCtrl = TextEditingController(text: contact.privateNotes);
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Notes sur ${contact.username}"),
          content: TextField(
            controller: noteCtrl,
            maxLines: 4,
            decoration: const InputDecoration(labelText: "Vos impressions…"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                _updateContactField(
                  contact,
                  'privateNotes',
                  noteCtrl.text.trim(),
                );
                Navigator.pop(ctx);
              },
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateContactField(
    KinkContact contact,
    String field,
    dynamic value,
  ) async {
    await _contactsCollection.doc(contact.id).update({field: value});
  }

  Future<void> _deleteContact(String docId) async {
    await _contactsCollection.doc(docId).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Contact supprimé.")));
  }

  void _sendPlumeTo(KinkContact contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Plume Secrète envoyée à ${contact.username} !")),
    );
  }

  List<KinkContact> _applySearch(List<KinkContact> all) {
    if (_searchQuery.isEmpty) return all;
    final lowerQ = _searchQuery.toLowerCase();
    return all.where((c) => c.username.toLowerCase().contains(lowerQ)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ma Kinksphère"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt, color: Colors.white),
            onPressed: _addContactDialog,
            tooltip: "Ajouter un contact",
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondkinksphere.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Rechercher…",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _searchQuery = _searchCtrl.text;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  user == null
                      ? const Center(
                        child: Text(
                          "Vous devez être connecté pour voir vos contacts",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                      : StreamBuilder<QuerySnapshot>(
                        stream:
                            _contactsCollection
                                .where('userId', isEqualTo: user.uid)
                                .snapshots(),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                "Erreur de chargement",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          List<KinkContact> contacts =
                              snapshot.data!.docs
                                  .map(
                                    (doc) => KinkContact.fromMap(
                                      doc.id,
                                      doc.data() as Map<String, dynamic>,
                                    ),
                                  )
                                  .toList();
                          contacts = _applySearch(contacts);
                          if (contacts.isEmpty) {
                            return const Center(
                              child: Text(
                                "Aucun contact trouvé.",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: contacts.length,
                            itemBuilder:
                                (ctx, index) =>
                                    _buildContactItem(contacts[index]),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(KinkContact contact) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () => _showContactMenu(contact),
        title: Text(
          contact.username,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          contact.isBlocked ? "🚫 (Bloqué)" : contact.status,
          style: const TextStyle(color: Colors.white70),
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (contact.isBlocked) const Icon(Icons.block, color: Colors.red),
            const SizedBox(width: 6),
            if (contact.isVisibilityRestricted)
              const Icon(Icons.lock, color: Colors.yellow),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.send, color: Colors.red),
          onPressed: () => _sendPlumeTo(contact),
        ),
      ),
    );
  }
}
