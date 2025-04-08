import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kinksme/models/message_style.dart';

class PlumeSecreteScreen extends StatefulWidget {
  final String text;
  final String signature;
  final MessageStyle style;
  final String? manualSignatureBase64;

  const PlumeSecreteScreen({
    super.key,
    required this.text,
    required this.signature,
    required this.style,
    this.manualSignatureBase64,
  });

  @override
  State<PlumeSecreteScreen> createState() => _PlumeSecreteScreenState();
}

class _PlumeSecreteScreenState extends State<PlumeSecreteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _showSignature = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getTextColor() {
    switch (widget.style) {
      case MessageStyle.soieArdente:
        return Colors.amber;
      case MessageStyle.voileDeSoie:
      case MessageStyle.feuilleClassique:
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  Color _getSignatureColor() {
    return _getTextColor().withOpacity(0.7);
  }

  Color _getSignatureBackgroundColor() {
    switch (widget.style) {
      case MessageStyle.soieArdente:
      case MessageStyle.voileDeSoie:
        return Colors.black.withOpacity(0.6);
      case MessageStyle.parcheminDAntan:
      case MessageStyle.ecritVintage:
      case MessageStyle.rouleauScelle:
      default:
        return Colors.white.withOpacity(0.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor();
    final sigColor = _getSignatureColor();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Plume Secrète"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.style.assetPath),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () => setState(() => _showSignature = !_showSignature),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (ctx, child) {
                        final visibleLen =
                            (_animation.value * widget.text.length).floor();
                        final visibleText =
                            widget.text.substring(0, visibleLen);
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            visibleText,
                            style: TextStyle(
                              fontFamily: 'DancingScript',
                              fontSize: 24,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (_showSignature)
                  widget.manualSignatureBase64 != null
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getSignatureBackgroundColor(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.memory(
                            base64Decode(widget.manualSignatureBase64!),
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Text(
                          widget.signature,
                          style: TextStyle(
                            fontSize: 18,
                            color: sigColor,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                else
                  const Text(
                    "Touchez pour révéler la signature",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/kinksphere');
                    ElevatedButton(
                      onPressed: () {
                        // 1. Redirection
                        Navigator.pushNamed(context, '/kinksphere');

                        // 2. Notif (snackbar)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Votre Plume Secrète a été remise à son destinataire.\nElle ne pourra pas être relue.",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            duration: Duration(seconds: 4),
                            backgroundColor: Colors.black87,
                          ),
                        );
                        // 3. Popup "s’est envolée"
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.black,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.local_fire_department,
                                    color: Colors.redAccent, size: 48),
                                SizedBox(height: 12),
                                Text(
                                  "Votre Plume s’est envolée…",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                      ),
                      child: const Text(
                        "ENVOYER",
                        style: TextStyle(
                          fontFamily: 'DancingScript',
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                  ),
                  child: const Text(
                    "ENVOYER",
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
