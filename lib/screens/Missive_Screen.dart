// missive_screen.dart
import 'package:flutter/material.dart';
import 'package:kinksme/models/message_style.dart'; // Import centralisé de l'enum

class MissiveScreen extends StatefulWidget {
  final String message;
  final String signature;
  final MessageStyle style;

  const MissiveScreen({
    super.key,
    required this.message,
    required this.signature,
    this.style = MessageStyle.parcheminDAntan,
  });

  @override
  State<MissiveScreen> createState() => _MissiveScreenState();
}

class _MissiveScreenState extends State<MissiveScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _showSignature = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  BoxDecoration _buildDecoration(MessageStyle style) {
    switch (style) {
      case MessageStyle.parcheminDAntan:
        return const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/parchemaindantan.png"),
            fit: BoxFit.cover,
          ),
        );
      case MessageStyle.feuilleClassique:
        return const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/feuilleclassique.png"),
            fit: BoxFit.cover,
          ),
        );
      case MessageStyle.voileDeSoie:
        return const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/voiledesoie.png"),
            fit: BoxFit.cover,
          ),
        );
      case MessageStyle.rouleauScelle:
        return const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/rouleauscelle.png"),
            fit: BoxFit.cover,
          ),
        );
      case MessageStyle.ecritVintage:
        return const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/ecritvintage.png"),
            fit: BoxFit.cover,
          ),
        );
      case MessageStyle.soieArdente:
        return const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/soieardente.png"),
            fit: BoxFit.cover,
          ),
        );
      default:
        return const BoxDecoration(color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Missive"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: _buildDecoration(widget.style),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _showSignature = !_showSignature;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final int totalLength = widget.message.length;
                      final int currentLength =
                          (_animation.value * totalLength).floor();
                      return SingleChildScrollView(
                        child: Text(
                          widget.message.substring(0, currentLength),
                          style: const TextStyle(
                            fontFamily: 'DancingScript',
                            fontSize: 24,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.verified, color: Colors.redAccent, size: 32),
                  ],
                ),
                const SizedBox(height: 16),
                _showSignature
                    ? Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.signature,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                    : const Text(
                      "Touchez pour révéler la signature",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
