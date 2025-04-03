import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String explanatoryText = """
✨ L'Âme de Kink's Me ✨  

Kink's Me est née d'une conviction intime : celle qu'on ne sublime pleinement ses désirs que dans la confiance, la subtilité et le respect absolu de chacun. En connaissant de près cet univers pour le vivre au quotidien avec Mon Lord, je continue de l'explorer. J'ai voulu créer un espace où l'audace côtoie naturellement l'élégance, où chaque rencontre devient une expérience authentique et profonde. 

Soucieuse de revisiter les codes traditionnels du BDSM sans les trahir, j'ai imaginé Kink's Me comme un univers subtil et délicat, où les mots prennent sens, les échanges deviennent précieux, et chaque utilisateur peut librement affirmer ses désirs tout en se sentant entièrement protégé. N'oubliez pas que le BDSM ne suit aucun modèle unique : chacun le vit et l'explore librement, selon ses envies, ses besoins et sa propre vérité intérieure. Ici, votre sécurité est précieuse, votre liberté respectée, et vos désirs sublimés. 

C'est cela, l'esprit véritable de Kink's Me. 🌹 
Kink's Me, powered by Lifeislife 🌹
""";

  void _onSavePressed(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Accueil sauvegardé")));
  }

  @override
  void initState() {
    super.initState();
    _markHomeSeen();
  }

  Future<void> _markHomeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenHome', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Le seuil des plaisirs"),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Sauvegarder",
            onPressed: () => _onSavePressed(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/fondhome.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        explanatoryText,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Bienvenue sur Kink's Me !",
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 38,
                      color: Color.fromARGB(255, 141, 6, 6),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async {
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/register');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(0, 242, 0, 0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Continuer",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
