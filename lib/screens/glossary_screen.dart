import 'package:flutter/material.dart';

class GlossaryScreen extends StatelessWidget {
  const GlossaryScreen({super.key});

  void _onSavePressed(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Glossaire sauvegardé")));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Grimoire des Sens"),
          backgroundColor: Colors.black87,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: "Sauvegarder",
              onPressed: () => _onSavePressed(context),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Abécédaire Sensuel"),
              Tab(text: "Éventail des Dominations"),
              Tab(text: "Origine du BDSM"),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fondglossaire.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Text(
                  lexiqueText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Text(
                  dominationsText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Text(
                  histoireText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const String lexiqueText = '''
A Abandonment Jeu de rôle où le soumis est momentanément laissé seul, créant un sentiment d’abandon contrôlé qui intensifie le lien émotionnel et la vulnérabilité assumée.  

Abrasion Effleurement délicat de la peau à l’aide de matériaux texturés (cuir, soie rugueuse, papier de verre) pour éveiller des sensations fines où la douleur et le plaisir se confondent.  

Accessoires Objets choisis avec amour (menottes, cravaches, bâillons, etc.) qui viennent sublimer la scène en ajoutant une dimension esthétique et sensorielle à l’échange.  

... [insérer l'intégralité du texte fourni précédemment pour l'Abécédaire] ...

LifeisLife
''';

const String dominationsText = '''
Contenu sur les différentes formes de domination à venir...
''';

const String histoireText = '''
A la source du BDSM

Loin d'être une simple pratique charnelle, le BDSM puise ses racines dans une profondeur symbolique et philosophique qui remonte aux origines des relations humaines...

... [insérer le texte complet fourni précédemment pour l'Histoire du BDSM] ...

LifeisLife
''';
