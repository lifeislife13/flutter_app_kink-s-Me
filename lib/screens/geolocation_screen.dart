import 'package:flutter/material.dart';
import 'home_screen.dart'; // ✅ Vérifie que ce fichier est bien importé !

class GeolocationScreen extends StatefulWidget {
  const GeolocationScreen({super.key});

  @override
  GeolocationScreenState createState() => GeolocationScreenState();
}

class GeolocationScreenState extends State<GeolocationScreen> {
  String _visibilityMode = "Privé"; // Mode par défaut
  bool _acceptedTerms = false; // Pour la case à cocher

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Paramètres de Localisation"),
        backgroundColor: Colors.red,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // 📍 Texte explicatif
                    const Text(
                      "Kink's Me vous permet de choisir votre visibilité.\n"
                      "Sélectionnez un mode selon votre confort.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),

                    const SizedBox(height: 20),

                    // 📍 Sélecteur de mode de visibilité
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        value: _visibilityMode,
                        dropdownColor: Colors.black,
                        isExpanded: true,
                        items:
                            ["Privé", "Entre amis", "Profils compatibles"].map((
                              String mode,
                            ) {
                              return DropdownMenuItem<String>(
                                value: mode,
                                child: Text(
                                  mode,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _visibilityMode = newValue!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 📍 Checkbox pour accepter les conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          activeColor: Colors.red,
                          onChanged: (bool? value) {
                            setState(() {
                              _acceptedTerms = value!;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "J'accepte les conditions d'utilisation.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 📍 Bouton Confirmer
                    ElevatedButton(
                      onPressed:
                          _acceptedTerms
                              ? () {
                                print("✅ Conditions acceptées !");
                                print(
                                  "🌍 Mode de visibilité sélectionné: $_visibilityMode",
                                );
                                print("🚀 Navigation vers HomeScreen !");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              }
                              : null, // Désactivé si conditions non acceptées
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _acceptedTerms ? Colors.red : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Confirmer",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
