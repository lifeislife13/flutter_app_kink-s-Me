import 'package:flutter/material.dart';

/// Popup de prudence pour le chat.
Future<bool> showChatPopup(BuildContext context) async {
  return (await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
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
            content: const Text(
              "Votre intimité est précieuse : préservez-la en partageant vos confidences avec soin et délicatesse.",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text("OK", style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text(
                  "Annuler",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      )) ??
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
            image: AssetImage("assets/fond.png"), // Votre fond d'écran
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            shrinkWrap: true, // Permet de réduire la hauteur au contenu
            physics:
                const NeverScrollableScrollPhysics(), // Désactive le scroll interne du GridView
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
              ),
              // Bouton Chat -> L'Antre des Murmures avec popup
              _buildMenuButton(
                context: context,
                asset: 'assets/murmure.png',
                label: "L'Antre des Murmures",
                route: '/chat',
                isChatButton: true,
              ),
              // Bouton Journal -> Mon Journal Brûlant / Plume Secrète
              _buildMenuButton(
                context: context,
                asset: 'assets/monjournalbrulant.png',
                label: "Mon Journal Brûlant\nPlume Secrète",
                route: '/journalBrulant',
              ),
              // Bouton Notifications -> Missive
              _buildMenuButton(
                context: context,
                asset: 'assets/missive.png',
                label: "Missive",
                route: '/notifications',
              ),
              // Bouton Ma Kinksphère (exemple)
              _buildMenuButton(
                context: context,
                asset: 'assets/kinksphere.png',
                label: "Ma Kinksphère",
                route: '/kinksphere',
              ),
              // Bouton Cercle des Murmures (exemple)
              _buildMenuButton(
                context: context,
                asset: 'assets/cercle.png',
                label: "Cercle des Murmures",
                route: '/cercleMurmures',
              ),
              // Bouton Kink Élégance (exemple)
              _buildMenuButton(
                context: context,
                asset: 'assets/kinkseal.png',
                label: "Kink Élégance",
                route: '/kinkElegance',
              ),
              // Bouton Mon Compte
              _buildMenuButton(
                context: context,
                asset: 'assets/moncompte.png',
                label: "Mon Compte",
                route: '/account',
              ),

              // Bouton Plan du site
              _buildMenuButton(
                context: context,
                asset: 'assets/plansite.png',
                label: "Plan du Site",
                route: '/planSite',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String asset,
    required String label,
    required String route,
    bool isChatButton = false,
  }) {
    return TextButton(
      onPressed: () async {
        if (isChatButton) {
          final proceed = await showChatPopup(context);
          if (!proceed) return;
        }
        Navigator.pushNamed(context, route);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image de fond du bouton
            Image.asset(asset, fit: BoxFit.cover),
            // Overlay semi-transparent pour uniformiser le fond
            Container(color: Colors.black.withOpacity(0.2)),
            // Label centré
            Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
