import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlanDuSiteScreen extends StatelessWidget {
  const PlanDuSiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    final List<Map<String, dynamic>> sections = [
      {'label': "Accueil (Home)", 'route': '/home', 'emoji': "🏠"},
      if (!isLoggedIn)
        {'label': "Inscription", 'route': '/register', 'emoji': "🧾"},
      {'label': "Présentation", 'route': '/presentation', 'emoji': "📖"},
      {
        'label': "Configuration Profil",
        'route': '/profileSetup',
        'emoji': "💡",
      },
      {
        'label': "Conditions / Mentions légales",
        'route': '/about',
        'emoji': "📜",
      },
      if (isLoggedIn)
        {
          'label': "Se déconnecter",
          'route': null,
          'emoji': "🚪",
        },
      if (isLoggedIn)
        {
          'label': "Feedback",
          'route': '/feedback',
          'emoji': "📝",
        },
      if (isLoggedIn)
        {
          'label': "Crédits Images & Ressources",
          'route': '/credits',
          'emoji': "💬",
        },
      if (isLoggedIn)
        {
          'label': "Mon Compte",
          'route': '/account',
          'emoji': "👤",
        },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Plan du Site"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/fondplansite.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final item = sections[index];
                return Card(
                  color: Colors.black.withOpacity(0.8),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    leading: Text(
                      item['emoji'],
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      item['label'],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                    ),
                    onTap: () async {
                      if (item['label'] == "Se déconnecter") {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.black,
                            title: const Text(
                              "Confirmer la déconnexion",
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
                              "Souhaitez-vous vraiment vous déconnecter ?",
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Annuler",
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("Se déconnecter",
                                    style: TextStyle(color: Colors.redAccent)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (_) => false,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Déconnexion réussie"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      } else {
                        Navigator.pushNamed(context, item['route']);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
