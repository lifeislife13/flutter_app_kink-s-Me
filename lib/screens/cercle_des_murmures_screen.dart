import 'package:flutter/material.dart';

class CercleDesMurmuresScreen extends StatefulWidget {
  const CercleDesMurmuresScreen({super.key});

  @override
  State<CercleDesMurmuresScreen> createState() =>
      _CercleDesMurmuresScreenState();
}

class _CercleDesMurmuresScreenState extends State<CercleDesMurmuresScreen> {
  final TextEditingController _postController = TextEditingController();
  final List<_MurPost> _posts = [];

  bool isFemaleUser = true; // À ajuster dynamiquement

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  void _createPost() {
    final text = _postController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _posts.insert(0, _MurPost(content: text, author: "MonProfil"));
      });
      _postController.clear();
    }
  }

  void _onSavePressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sauvegarde effectuée depuis le Cercle des Murmures"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cercle des Murmures"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Sauvegarder",
            onPressed: _onSavePressed,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/fondcercle.png", fit: BoxFit.cover),
          ),
          Column(
            children: [
              Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _postController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Exprimez-vous...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.red),
                      onPressed: _createPost,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _posts.isEmpty
                    ? const Center(
                        child: Text(
                          "Aucun murmure pour l'instant.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _posts.length,
                        itemBuilder: (ctx, i) {
                          final post = _posts[i];
                          return _buildPostItem(post);
                        },
                      ),
              ),
              // ✅ Le bouton magique bien placé !
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/highlightedKinks');
                  },
                  icon: const Icon(Icons.stars, color: Colors.amber),
                  label: const Text(
                    "✨ Voir les Kink Élégants",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.amber),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem(_MurPost post) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.author,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(post.content, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isFemaleUser)
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Valider",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Signaler",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MurPost {
  final String content;
  final String author;

  _MurPost({required this.content, required this.author});
}
