import 'package:flutter/material.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Crédits & Images"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            Text(
              "🖼️ Images utilisées dans l'application :",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              "Certaines illustrations proviennent de la banque d’images gratuite Freepik.\n"
              "Merci aux artistes pour leurs créations incroyables !\n\n"
              "https://www.freepik.com/",
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 20),
            Text(
              "📜 Polices utilisées :",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "- Dancing Script\n- Amatic SC\n- Great Vibes\n- Pacifico",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
