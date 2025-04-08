import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? _pseudo;
  bool _isPremium = false;
  DateTime? _premiumUntil;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      final pseudo = data['pseudo'] ?? "Déesse Noire";
      final isPremium = data['isPremium'] == true;
      final premiumUntilTimestamp = data['premiumUntil'];
      final premiumUntil = premiumUntilTimestamp != null
          ? (premiumUntilTimestamp as Timestamp).toDate()
          : null;

      setState(() {
        _pseudo = pseudo;
        _isPremium = isPremium;
        _premiumUntil = premiumUntil;
        _isLoading = false;
      });
    }
  }

  String _buildPremiumInfo() {
    if (!_isPremium || _premiumUntil == null) {
      return "Statut : Membre classique 🖤";
    }

    final remainingDays = _premiumUntil!.difference(DateTime.now()).inDays;

    if (remainingDays <= 0) {
      return "Votre Écrin Premium a expiré.";
    } else if (remainingDays == 1) {
      // TODO: envoyer un mail ici
      return "Dernier jour de magie 💫 — Votre Écrin Premium se termine bientôt.";
    } else {
      return "Écrin Premium actif ✨ ($remainingDays jours restants)";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Compte"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/fondmoncompte.png", fit: BoxFit.cover),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            _pseudo ?? "Déesse Noire",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _buildPremiumInfo(),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white38),
                        ListTile(
                          leading: const Icon(Icons.edit, color: Colors.white),
                          title: const Text("Modifier mon pseudo",
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            // TODO: Ajouter l'écran de modification de pseudo
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.card_giftcard,
                              color: Colors.amber),
                          title: const Text("Offrir un Écrin",
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            // TODO: rediriger vers offre cadeau
                          },
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.settings, color: Colors.grey),
                          title: const Text("Paramètres",
                              style: TextStyle(color: Colors.white)),
                          onTap: () =>
                              Navigator.pushNamed(context, '/settings'),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
