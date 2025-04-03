import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BoudoirScreen extends StatefulWidget {
  const BoudoirScreen({super.key});

  @override
  State<BoudoirScreen> createState() => _BoudoirScreenState();
}

class _BoudoirScreenState extends State<BoudoirScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Stream<QuerySnapshot> _communityTextsStream;
  String _searchQuery = "";
  bool _autoPublishEnabled = false;

  final String fixedText = '''
Je compte et remercie  

Ressentir et accorder le pouvoir de la main tombant en rythme, érotique (punitive qui n’a pas vocation à faire plaisir, elle reste cadencée et rythmée). Il en va de même avec le martinet, tout comme la main forte et précise qui, au-delà de l’image qu’ils renvoient, procurent des sensations inédites. Réussir à créer l’interstice idéal entre le plaisir et la douleur… LifeisLife

Ode A Votre nom,  

J’ai erré pour Vous, A Votre nom, Je me suis brisée pour vous, A Votre nom, J’ai brûlé mes idées reçues, A Votre nom, Je me suis ouverte et reconstruite, A Votre nom, Vous avez pris différents visages, tous unis, A Votre nom j’ai fléchi, mon regard humblement baissé, A Votre nom, Je vous appartiens LifeisLife
''';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _communityTextsStream =
        FirebaseFirestore.instance
            .collection('boudoirEcrits')
            .orderBy('timestamp', descending: true)
            .snapshots();
    _loadAutoPublishPreference();
  }

  /// On lit les arguments pour savoir si on doit aller direct sur l’onglet “Communauté”
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      if (args['initialTab'] == 'communautaire') {
        _tabController.index = 1; // Onglet “Communauté”
      }
    }
  }

  Future<void> _loadAutoPublishPreference() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists && doc.data()!.containsKey('autoPublish')) {
        setState(() {
          _autoPublishEnabled = doc['autoPublish'] == true;
        });
      }
    }
  }

  Future<void> _validatePublication() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('boudoirEcrits')
            .where('userId', isEqualTo: uid)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      await FirebaseFirestore.instance
          .collection('boudoirEcrits')
          .doc(doc.id)
          .update({'isValidated': true});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Publication validée !")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aucune publication trouvée.")),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Boudoir des Écrits"),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Texte fondateur"), Tab(text: "Communauté")],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondboudoir.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Onglet 1 : Texte fondateur (sans le Switch)
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                fixedText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            // Onglet 2 : Communauté
            Column(
              children: [
                // Barre de recherche
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Rechercher un texte...",
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.black45,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),

                // Le Switch “Validation avant publication”
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        "Validation avant publication :",
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: _autoPublishEnabled,
                        onChanged: (value) async {
                          setState(() {
                            _autoPublishEnabled = value;
                          });
                          final uid = FirebaseAuth.instance.currentUser?.uid;
                          if (uid != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .set({
                                  'autoPublish': value,
                                }, SetOptions(merge: true));
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Liste des textes communautaires
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _communityTextsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "Aucun texte communautaire pour le moment.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      final filteredDocs =
                          snapshot.data!.docs.where((doc) {
                            final text =
                                (doc['text'] ?? '').toString().toLowerCase();
                            final signature =
                                (doc['signature'] ?? '')
                                    .toString()
                                    .toLowerCase();
                            return text.contains(_searchQuery) ||
                                signature.contains(_searchQuery);
                          }).toList();

                      if (filteredDocs.isEmpty) {
                        return const Center(
                          child: Text(
                            "Aucun résultat pour cette recherche.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children:
                            filteredDocs.map((doc) {
                              final text = doc['text'] ?? '';
                              final signature = doc['signature'] ?? '';
                              return Card(
                                color: Colors.black54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Titre = 1ère ligne
                                      Text(
                                        text.split('\n').first,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Contenu complet
                                      Text(
                                        text,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          height: 1.6,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "- $signature",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white.withOpacity(
                                              0.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      );
                    },
                  ),
                ),

                // Bouton de validation
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: _validatePublication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "VALIDER",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
