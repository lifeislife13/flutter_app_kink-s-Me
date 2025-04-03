// plume_secrete_screen.dart
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

  BoxDecoration _buildDecoration() {
    switch (widget.style) {
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

  Color _getTextColor() {
    switch (widget.style) {
      case MessageStyle.soieArdente:
        return Colors.amber;
      case MessageStyle.feuilleClassique:
      case MessageStyle.voileDeSoie:
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  Color _getSignatureColor() {
    switch (widget.style) {
      case MessageStyle.soieArdente:
        return Colors.amber;
      case MessageStyle.feuilleClassique:
      case MessageStyle.voileDeSoie:
        return Colors.white;
      default:
        return Colors.grey;
    }
  }

  Color _getSignatureBackgroundColor() {
    switch (widget.style) {
      case MessageStyle.soieArdente:
        return Colors.black.withOpacity(0.6);
      case MessageStyle.feuilleClassique:
      case MessageStyle.voileDeSoie:
        return Colors.grey.shade900.withOpacity(0.7);
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
        decoration: _buildDecoration(),
        width: double.infinity,
        height: double.infinity,
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
                        final totalLen = widget.text.length;
                        final currentLen =
                            (totalLen * _animation.value).floor();
                        final visibleText = widget.text.substring(
                          0,
                          currentLen,
                        );
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
                          height: 50,
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
