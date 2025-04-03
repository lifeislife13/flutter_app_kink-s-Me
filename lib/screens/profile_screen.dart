import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _buddyCtrl = TextEditingController();
  final TextEditingController _safewordCtrl = TextEditingController();
  final TextEditingController _profileTextCtrl = TextEditingController();

  User? _user;
  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _buddyCtrl.dispose();
    _safewordCtrl.dispose();
    _profileTextCtrl.dispose();
    super.dispose();
  }

  // Vérifier si l'utilisateur est connecté et charger son profil
  void _loadUserProfile() async {
    _user = _auth.currentUser;
    if (_user == null) {
      setState(() => _isLoading = false);
      return;
    }

    final docRef = _firestore.collection('users').doc(_user!.uid);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      // Si le profil n'existe pas, on le crée automatiquement
      await docRef.set({
        "pseudo": "Anonyme",
        "kinkSeals": 0,
        "buddy": "",
        "safeword": "",
        "profileText": "Aucun texte",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }

    setState(() {
      _userData = docSnapshot.data() ?? {};
      _isLoading = false;
    });
  }

  // Mettre à jour un champ du profil
  Future<void> _updateField(String field, dynamic value) async {
    if (_user == null) return;

    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        field: value,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      // Mise à jour locale pour éviter un rechargement Firestore
      setState(() {
        _userData![field] = value;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$field mis à jour !")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur Firestore: $e")));
    }
  }

  // Ajouter un KinkSeal
  Future<void> _addKinkSeal() async {
    final currentCount = _userData?["kinkSeals"] ?? 0;
    await _updateField("kinkSeals", currentCount + 1);
  }

  // Popup pour modifier les infos du profil
  void _showEditDialog(String champ, String currentVal) {
    final ctrl = TextEditingController(text: currentVal);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(
            "Modifier $champ",
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: ctrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Nouveau $champ",
              hintStyle: const TextStyle(color: Colors.white54),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Annuler", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                final newVal = ctrl.text.trim();
                if (newVal.isNotEmpty) {
                  _updateField(champ, newVal);
                }
                Navigator.pop(ctx);
              },
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Veuillez vous connecter.",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Mon Profil"),
        backgroundColor: Colors.black,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/avatar.png"),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Pseudo : ${_userData?["pseudo"] ?? "Anonyme"}",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "KinkSeals : ${_userData?["kinkSeals"] ?? 0}",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _addKinkSeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text("Offrir un KinkSeal"),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.white54),
                  ListTile(
                    title: Text(
                      "Buddy virtuel",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _userData?["buddy"] ?? "",
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: Icon(Icons.edit, color: Colors.red),
                    onTap:
                        () =>
                            _showEditDialog("buddy", _userData?["buddy"] ?? ""),
                  ),
                  ListTile(
                    title: Text(
                      "Safeword",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _userData?["safeword"] ?? "",
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: Icon(Icons.edit, color: Colors.red),
                    onTap:
                        () => _showEditDialog(
                          "safeword",
                          _userData?["safeword"] ?? "",
                        ),
                  ),
                  Divider(color: Colors.white54),
                  ListTile(
                    title: Text(
                      "Mon Profil / Bio",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _userData?["profileText"] ?? "Aucun texte",
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: Icon(Icons.edit, color: Colors.red),
                    onTap:
                        () => _showEditDialog(
                          "profileText",
                          _userData?["profileText"] ?? "",
                        ),
                  ),
                ],
              ),
    );
  }
}
