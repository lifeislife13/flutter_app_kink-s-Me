import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kinksme/screens/profile_setup_screen.dart';

class PresentationScreen extends StatefulWidget {
  const PresentationScreen({super.key});

  @override
  State<PresentationScreen> createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  @override
  void initState() {
    super.initState();
    _checkIfAlreadySeen();
  }

  Future<void> _checkIfAlreadySeen() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadySeen = prefs.getBool('seenPresentation') ?? false;

    if (alreadySeen && mounted) {
      Navigator.pushReplacementNamed(context, '/profileSetup');
    }
  }

  void _handleContinue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenPresentation', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bienvenue sur Kink’s Me"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/presentation.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    """
✨ Bienvenue sur Kinks’Me : Guide d'utilisation rapide ✨

Kink's Me est une application élégante destinée aux rencontres BDSM, qui respecte votre intimité et sublime vos désirs.

🔹Les principaux outils :

Journal Brûlant : 
Votre journal intime, sécurisé, privé et personnel. Écrivez et sauvegardez librement vos pensées, émotions ou expériences.

Plume Secrète (fonction spéciale) : 
Depuis votre Journal Brûlant, sélectionnez un extrait précis de votre texte et envoyez-le discrètement à vos amis choisis.

Missive : 
Messagerie privée élégante pour échanger des messages personnalisés.

Antre des Murmures (Chat) : 
Discutez en direct avec vos contacts, envoyez des photos éphémères.

Boussole des Désirs (Carte) : 
Découvrez des profils compatibles près de chez vous.

Agenda : 
Calendrier des événements BDSM, Munch, libertins...

Forge des Plaisirs (Boutique) : 
Accessoires BDSM sélectionnés pour leur qualité et élégance.

Grimoire des Sens (Glossaire) : 
Lexique clair expliquant les termes et pratiques BDSM.

Boudoir des Écrits (Lecture) : 
Récits et textes érotiques soigneusement choisis.

Ma Kinksphère :
Gérez vos contacts favoris, définissez vos affinités, partagez vos Plumes Secrètes.

🔹Les Notifications :

🔇️ : Nouveau match
🔥 : Match intense
👑 : Rencontre exceptionnelle
📜 : Nouvelle missive
🎭 : Invitation à un jeu
⛓️ : Notification liée à votre sécurité

🔹 Fonctionnement rapide :

Inscrivez-vous, définissez vos désirs (“kinks”).
Découvrez des profils via la “Boussole des Désirs”.
Échangez via l’Antre ou les Missives.
Écrivez dans votre Journal et partagez avec la Plume Secrète.

Bienvenue dans l’univers raffiné de Kink’s Me.
                    """,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 153, 0, 0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Continuer",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
