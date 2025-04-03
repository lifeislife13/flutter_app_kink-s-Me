import 'package:flutter/material.dart';

class PlanDuSiteScreen extends StatelessWidget {
  const PlanDuSiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sections = [
      {'label': "Accueil (Home)", 'route': '/home', 'emoji': "🏠"},
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
                    onTap: () {
                      Navigator.pushNamed(context, item['route']).then((_) {
                        Navigator.pushReplacementNamed(context, '/planSite');
                      });
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
