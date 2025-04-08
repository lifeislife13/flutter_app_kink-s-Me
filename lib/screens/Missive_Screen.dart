import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kinksme/models/message_style.dart';

class MissiveScreen extends StatefulWidget {
  final String message;
  final String signature;
  final MessageStyle style;
  final String? manualSignatureBase64;

  const MissiveScreen({
    super.key,
    required this.message,
    required this.signature,
    this.style = MessageStyle.parcheminDAntan,
    this.manualSignatureBase64,
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

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      image: DecorationImage(
        image: AssetImage(widget.style.assetPath),
        fit: BoxFit.cover,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Missive"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: decoration,
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
                if (_showSignature)
                  Align(
                    alignment: Alignment.centerRight,
                    child: widget.manualSignatureBase64 != null
                        ? Image.memory(
                            base64Decode(widget.manualSignatureBase64!),
                            height: 60,
                          )
                        : Text(
                            widget.signature,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                  )
                else
                  const Text(
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
