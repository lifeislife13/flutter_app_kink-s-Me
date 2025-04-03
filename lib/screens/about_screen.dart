import 'package:flutter/material.dart';

/// Page dédiée aux Mentions Légales, CGU/CGV et Politique de Confidentialité
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  final TextStyle titleStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  final TextStyle bodyStyle = const TextStyle(
    fontSize: 16,
    color: Colors.white70,
    height: 1.4,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mentions Légales et Informations"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mentions Légales
            Text("Mentions Légales", style: titleStyle),
            const SizedBox(height: 8),
            Text(
              "Éditeur:\n"
              "Nom de l'éditeur : [Votre Nom/Entreprise]\n"
              "Adresse : [Adresse complète]\n"
              "Numéro SIRET : [Si applicable]\n"
              "Contact : [Email / téléphone]\n\n"
              "Hébergeur:\n"
              "Nom de l'hébergeur : [Nom de l'hébergeur]\n"
              "Adresse : [Adresse complète de l'hébergeur]\n\n"
              "Propriété Intellectuelle:\n"
              "Tous les contenus (textes, images, logos, etc.) présents sur l'application sont protégés par le droit d'auteur. Toute reproduction sans autorisation expresse est interdite.",
              style: bodyStyle,
            ),
            const SizedBox(height: 16),

            // Conditions Générales d'Utilisation (CGU)
            Text("Conditions Générales d'Utilisation (CGU)", style: titleStyle),
            const SizedBox(height: 8),
            Text(
              "Article 1 – Objet\n"
              "Le présent document définit les modalités et conditions d'utilisation de l'application \"Kink's Me\". En accédant à l'application, l'utilisateur accepte sans réserve les présentes Conditions Générales d'Utilisation.\n\n"
              "Article 2 – Accès et Utilisation\n"
              "L'application est accessible gratuitement sur les plateformes Android et iOS. L'utilisateur s'engage à utiliser l'application conformément aux lois en vigueur et aux présentes CGU. Toute utilisation abusive ou frauduleuse pourra entraîner la suspension ou la suppression du compte utilisateur.\n\n"
              "Article 3 – Inscription et Sécurité\n"
              "Lors de l'inscription, l'utilisateur doit fournir des informations exactes et complètes. Il est responsable de la confidentialité de ses identifiants de connexion et s'engage à notifier immédiatement l'éditeur en cas d'utilisation non autorisée de son compte.\n\n"
              "Article 4 – Responsabilités\n"
              "L'éditeur décline toute responsabilité en cas d'utilisation inappropriée de l'application. L'utilisateur est seul responsable de ses interactions et s'engage à respecter les autres membres de la communauté. L'application s'engage toutefois à mettre en place des dispositifs de sécurité et des mesures de modération.\n\n"
              "Article 5 – Modification des CGU\n"
              "L'éditeur se réserve le droit de modifier les présentes conditions à tout moment. Les utilisateurs seront informés des modifications majeures via l'application et/ou par email.",
              style: bodyStyle,
            ),
            const SizedBox(height: 16),

            // Conditions Générales de Vente (CGV)
            Text("Conditions Générales de Vente (CGV)", style: titleStyle),
            const SizedBox(height: 8),
            Text(
              "Article 1 – Objet\n"
              "Les présentes Conditions Générales de Vente régissent la vente de produits et/ou services proposés via l'application \"Kink's Me\", lorsqu'ils sont disponibles.\n\n"
              "Article 2 – Commandes\n"
              "Les commandes passées via l'application sont soumises à acceptation par l'éditeur. L'utilisateur recevra une confirmation par email après validation de sa commande.\n\n"
              "Article 3 – Prix et Paiement\n"
              "Les prix affichés sont en euros et incluent toutes les taxes applicables. Le paiement s'effectue via des moyens sécurisés fournis par la plateforme (Google Play, App Store ou autre).\n\n"
              "Article 4 – Livraison et Droit de Rétractation\n"
              "Les produits ou services commandés seront livrés dans les délais indiqués lors de la commande. Conformément à la législation en vigueur, l'utilisateur dispose d'un délai de 14 jours pour exercer son droit de rétractation, sauf exceptions prévues par la loi.\n\n"
              "Article 5 – Réclamations et Service Client\n"
              "En cas de réclamation, l'utilisateur est invité à contacter le service client à l'adresse suivante : contactkinksme.com.",
              style: bodyStyle,
            ),
            const SizedBox(height: 16),

            // Politique de Confidentialité
            Text("Politique de Confidentialité", style: titleStyle),
            const SizedBox(height: 8),
            Text(
              "1. Collecte des Données\n"
              "L'application collecte des données personnelles (par exemple, l'email, le nom d'utilisateur, les préférences) nécessaires à son fonctionnement et à l'amélioration de l'expérience utilisateur.\n\n"
              "2. Utilisation des Données\n"
              "Les données collectées sont utilisées pour :\n"
              "- Permettre la création et la gestion du compte utilisateur.\n"
              "- Personnaliser l'expérience (par exemple, recommandations, affichage de contenus).\n"
              "- Communiquer avec l'utilisateur (email de confirmation, notifications, etc.).\n"
              "Les données ne seront jamais vendues à des tiers.\n\n"
              "3. Sécurité des Données\n"
              "Des mesures de sécurité techniques et organisationnelles sont mises en place pour protéger les données personnelles contre toute divulgation ou accès non autorisé.\n\n"
              "4. Conservation des Données\n"
              "Les données sont conservées pendant la durée nécessaire aux finalités pour lesquelles elles ont été collectées, conformément à la législation en vigueur.\n\n"
              "5. Droits des Utilisateurs\n"
              "L'utilisateur dispose d'un droit d'accès, de rectification, d'opposition et de suppression de ses données personnelles. Pour exercer ces droits, l'utilisateur peut nous contacter à l'adresse suivante : [adresse email].\n\n"
              "6. Modifications de la Politique de Confidentialité\n"
              "Nous nous réservons le droit de modifier cette politique de confidentialité. Les utilisateurs seront informés des changements par une mise à jour de la date de dernière révision.",
              style: bodyStyle,
            ),
            const SizedBox(height: 16),

            // Contact
            Text("Contact", style: titleStyle),
            const SizedBox(height: 8),
            Text(
              "Pour toute question ou réclamation, veuillez nous contacter à :contactkinksme.com",
              style: bodyStyle,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Ici, vous pouvez définir l'action (par exemple, ouvrir un formulaire de contact)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Contactez-nous",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
