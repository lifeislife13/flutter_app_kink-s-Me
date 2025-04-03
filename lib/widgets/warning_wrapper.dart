import 'package:flutter/material.dart';

/// Widget qui affiche le bandeau d'avertissement.
class WarningBanner extends StatelessWidget {
  const WarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Tu peux changer la couleur de fond si nécessaire (ici noir semi-transparent)
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: const Center(
        child: Text(
          "Privilégions les échanges authentiques et respectueux. Ne partagez pas vos coordonnées ni d'argent ! Si vous avez des fonds à dépenser, soutenez plutôt Kink’s Me pour que cette communauté continue de grandir !",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 175, 3, 3), // texte en rouge foncé
            fontSize: 12,
            fontWeight: FontWeight.bold,
            // Aucun attribut qui pourrait créer un surlignage n'est présent
          ),
        ),
      ),
    );
  }
}

/// Ce widget enveloppe le contenu de la page en ajoutant le WarningBanner en haut.
class WarningWrapper extends StatelessWidget {
  final Widget child;

  const WarningWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WarningBanner(),
        Expanded(child: child),
      ],
    );
  }
}
