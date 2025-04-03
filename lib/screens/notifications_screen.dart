import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Liste des messages envoyés
  final List<Map<String, dynamic>> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Envoie un nouveau message
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez écrire un message.")),
      );
      return;
    }
    setState(() {
      _messages.add({
        'text': text,
        'signature': "Signature de messagerie",
        'timestamp': DateTime.now(),
      });
    });
    _messageController.clear();
  }

  // Affichage d'un item (transparent, texte blanc)
  Widget _buildMessageItem(Map<String, dynamic> message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.transparent, // plus aucune image
      child: ListTile(
        title: Text(
          message['text'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'DancingScript',
          ),
        ),
        subtitle: Text(
          message['signature'],
          style: const TextStyle(
            color: Colors.white70,
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: Text(
          _formatTime(message['timestamp']),
          style: const TextStyle(color: Colors.white54, fontSize: 22),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messagerie"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondmissive.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child:
                  _messages.isEmpty
                      ? const Center(
                        child: Text(
                          "Aucun message envoyé.",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageItem(_messages[index]);
                        },
                      ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Écris ton message...",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.red),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
