import 'package:flutter/material.dart';

class ProfileListScreen extends StatefulWidget {
  const ProfileListScreen({super.key});

  @override
  _ProfileListScreenState createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  // Exemple de données à afficher dans la liste
  final List<Map<String, String>> _items = [
    {
      "title": "Profil",
      "subtitle": "Paramètres de ton profil",
      "icon":
          "assets/avatar.png", // si tu as un avatar, sinon on utilisera un placeholder
    },
    {
      "title": "Email",
      "subtitle": "[email protected]",
      "icon": "assets/avatar.png",
    },
    {
      "title": "Photo Profil",
      "subtitle": "Image de profil personnalisée",
      "icon": "assets/avatar.png",
    },
    {
      "title": "Photo F",
      "subtitle": "Encore une photo aléatoire",
      "icon": "assets/avatar.png",
    },
    {
      "title": "Kinks",
      "subtitle": "Voir / Modifier tes kinks",
      "icon": "assets/avatar.png",
    },
    // Ajoute autant d'items que tu veux...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fond noir comme sur ta capture
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ---------------------------
            // Header (zone supérieure)
            // ---------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              // petit dégradé du noir vers un rouge très foncé
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Color.fromARGB(255, 198, 5, 5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Avatar rouge/noir
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.red,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person, color: Colors.red, size: 50),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Ligne de boutons "Signup" / "Password" (ou ce que tu veux)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Bouton SignUp
                      ElevatedButton(
                        onPressed: () {
                          // TODO : action "Signup" ?
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "SignUp",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Bouton Password
                      ElevatedButton(
                        onPressed: () {
                          // TODO : action "Password" ?
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "Password",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ---------------------------
            // Liste (le corps de l'écran)
            // ---------------------------
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _buildListItem(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire un "tile" (ligne) de la liste
  Widget _buildListItem(Map<String, String> item) {
    // Couleurs
    const titleColor = Colors.white;
    const subtitleColor = Colors.white54;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white12, // fond sombre
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // L'icône ou l'image à gauche
          const CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.person, color: Colors.black),
            // Si tu veux charger un AssetImage, fais comme ceci :
            // backgroundImage: AssetImage(item["icon"] ?? ""),
          ),
          const SizedBox(width: 12),

          // Textes (title + subtitle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"] ?? "",
                  style: const TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item["subtitle"] ?? "",
                  style: const TextStyle(color: subtitleColor, fontSize: 14),
                ),
              ],
            ),
          ),

          // Icône "coeur" à droite
          IconButton(
            onPressed: () {
              // TODO : action ex: "like" ?
            },
            icon: const Icon(Icons.favorite, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
