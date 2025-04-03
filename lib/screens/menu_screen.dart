import 'package:flutter/material.dart';

/// Affiche un pop-up d'avertissement pour la carte (optionnel)
Future<bool> showMapSafetyPopup(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black87,
            title: const Text(
              "Invitation à la Prudence",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: const SingleChildScrollView(
              child: Text(
                "Votre intimité est précieuse : préservez-la en partageant vos confidences avec soin et délicatesse. Veillez à toujours rester à l’écoute de vos ressentis lors de chaque rencontre. Appuyez sur OK pour poursuivre votre voyage.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  "Annuler",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ) ??
      false;
}

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon espace intime"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fond.png"), // Fond général du menu
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Bouton Glossaire -> Le Grimoire des Sens
            _buildMenuButton(
              context: context,
              asset: 'assets/grimoire.png',
              label: "Le Grimoire des Sens",
              route: '/glossary',
            ),
            // Bouton Écrits -> Le Boudoir des Écrits
            _buildMenuButton(
              context: context,
              asset: 'assets/leboudoirdesecrits.png',
              label: "Le Boudoir des Écrits",
              route: '/boudoir',
            ),
            // Bouton Agenda
            _buildMenuButton(
              context: context,
              asset: 'assets/agenda.png',
              label: "Agenda",
              route: '/agenda',
            ),
            // Bouton Boutique -> La Forge des Désirs
            _buildMenuButton(
              context: context,
              asset: 'assets/laforge.png',
              label: "La Forge des Désirs",
              route: '/boutique',
            ),
            // Bouton Carte -> La Boussole des Désirs
            _buildMenuButton(
              context: context,
              asset: 'assets/boussole.png',
              label: "La Boussole des Désirs",
              route: '/map',
              isMapButton: true,
            ),
            // Bouton Chat -> L'Antre des Murmures
            _buildMenuButton(
              context: context,
              asset: 'assets/murmure.png',
              label: "L'Antre des Murmures",
              route: '/chat',
            ),
            // Bouton Journal -> Mon Journal Brûlant / Plume Secrète
            _buildMenuButton(
              context: context,
              asset: 'assets/monjournalbrulant.png',
              label: "Mon Journal Brûlant\nPlume Secrète",
              route: '/journal',
            ),
            // Bouton liste d'amis -> Ma Kinksphere
            _buildMenuButton(
              context: context,
              asset: 'assets/kinksphere.png',
              label: "Ma Kinksphère",
              route: '/kinksphere',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String asset,
    required String label,
    required String route,
    bool isMapButton = false,
  }) {
    return TextButton(
      onPressed: () async {
        if (isMapButton) {
          bool proceed = await showMapSafetyPopup(context);
          if (proceed) {
            Navigator.pushNamed(context, route);
          }
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        // Pas de fond ou d'ombre supplémentaire
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(asset), fit: BoxFit.cover),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
