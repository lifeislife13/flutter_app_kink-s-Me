import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitFeedback() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() => _isSubmitting = true);

    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? "anonyme";
    final email = user?.email ?? "non communiqué";

    try {
      await FirebaseFirestore.instance.collection("feedbacks").add({
        'uid': uid,
        'email': email,
        'message': message,
        'timestamp': Timestamp.now(),
      });

      _controller.clear();

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.black,
            content: const Text(
              "Merci pour votre retour 🖋️\n\nChaque mot compte pour nous.",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child:
                    const Text("Fermer", style: TextStyle(color: Colors.red)),
              )
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint("Erreur enregistrement feedback: $e");
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Votre retour d'expérience"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/fondjournal.png", fit: BoxFit.cover),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Partagez-nous vos ressentis, idées, coups de cœur ou suggestions 💌",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  maxLines: 6,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Votre message ici...",
                    hintStyle: const TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  icon: const Icon(Icons.send),
                  label: const Text("Envoyer"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
