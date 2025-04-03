import 'package:flutter/material.dart';

class ChatAndMessagingScreen extends StatefulWidget {
  final bool isChat;
  final String userPseudo;
  final String userPhoto;

  const ChatAndMessagingScreen({
    super.key,
    required this.isChat,
    required this.userPseudo,
    required this.userPhoto,
  });

  @override
  State<ChatAndMessagingScreen> createState() => _ChatAndMessagingScreenState();
}

class _ChatAndMessagingScreenState extends State<ChatAndMessagingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<TextMessage> _textMessages = [];
  final List<PhotoMessage> _photoMessages = [];
  double _photoLifetimeSeconds = 30;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendTextMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    setState(() {
      _textMessages.add(TextMessage(text: text, createdAt: now));
    });
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  List<dynamic> get _allMessages {
    final combined = <dynamic>[];
    combined.addAll(_textMessages);
    if (widget.isChat) combined.addAll(_photoMessages);
    combined.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return combined;
  }

  Widget _buildMessageBubble(dynamic msg) {
    final timeString = _formatTime(msg.createdAt);
    if (msg is TextMessage) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                timeString,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  Widget _buildSendBar() {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          if (widget.isChat)
            IconButton(
              icon: const Icon(Icons.add_photo_alternate, color: Colors.red),
              onPressed: () {},
            ),
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Écris un message...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.red),
            onPressed: _sendTextMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoLifetimeSlider() {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          const Text(
            "Durée photo (s) :",
            style: TextStyle(color: Colors.white),
          ),
          Expanded(
            child: Slider(
              value: _photoLifetimeSeconds,
              min: 10,
              max: 120,
              divisions: 11,
              label: "\${_photoLifetimeSeconds.round()} s",
              onChanged: (v) {
                setState(() {
                  _photoLifetimeSeconds = v;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundAsset =
        widget.isChat ? "assets/fondchat.png" : "assets/fondmissive.png";
    final bubbles = _allMessages.map(_buildMessageBubble).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  widget.userPhoto.isNotEmpty
                      ? NetworkImage(widget.userPhoto)
                      : const AssetImage('assets/avatar.png') as ImageProvider,
            ),
            const SizedBox(width: 10),
            Text(widget.userPseudo),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(backgroundAsset, fit: BoxFit.cover),
          ),
          Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: bubbles,
                ),
              ),
              if (widget.isChat) _buildPhotoLifetimeSlider(),
              _buildSendBar(),
            ],
          ),
        ],
      ),
    );
  }
}

class TextMessage {
  final String text;
  final DateTime createdAt;

  TextMessage({required this.text, required this.createdAt});
}

class PhotoMessage {
  final String imagePath;
  final DateTime createdAt;
  final Duration lifetime;

  PhotoMessage({
    required this.imagePath,
    required this.createdAt,
    required this.lifetime,
  });

  bool get isExpired => DateTime.now().isAfter(createdAt.add(lifetime));
}
