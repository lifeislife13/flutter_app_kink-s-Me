import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:kinksme/models/message_style.dart';

class PersonnalisationDialog extends StatefulWidget {
  final MessageStyle initialStyle;
  final String initialSignature;
  final String? initialManualSignatureBase64;
  final void Function(
    String signatureText,
    MessageStyle style,
    String? signatureImage,
  )
  onConfirmed;

  const PersonnalisationDialog({
    super.key,
    required this.initialStyle,
    required this.initialSignature,
    required this.onConfirmed,
    this.initialManualSignatureBase64,
  });

  @override
  State<PersonnalisationDialog> createState() => _PersonnalisationDialogState();
}

class _PersonnalisationDialogState extends State<PersonnalisationDialog> {
  late MessageStyle _style;
  late TextEditingController _signatureTextController;
  String? _manualSignatureBase64;
  late final SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    _style = widget.initialStyle;
    _signatureTextController = TextEditingController(
      text: widget.initialSignature,
    );
    _manualSignatureBase64 = widget.initialManualSignatureBase64;
    _signatureController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _signatureTextController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _openSignaturePad() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Signature manuelle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 150,
                width: 300,
                child: Signature(
                  controller: _signatureController,
                  backgroundColor: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => _signatureController.clear(),
                child: const Text("Effacer"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_signatureController.isNotEmpty) {
                  final bytes = await _signatureController.toPngBytes();
                  if (bytes != null) {
                    setState(
                      () => _manualSignatureBase64 = base64Encode(bytes),
                    );
                  }
                }
                Navigator.of(context).pop();
              },
              child: const Text("Valider"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Annuler"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Personnaliser votre journal"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Choisissez un style :"),
            ...MessageStyle.values.map(
              (style) => RadioListTile<MessageStyle>(
                title: Text(style.name),
                value: style,
                groupValue: _style,
                onChanged: (value) => setState(() => _style = value!),
              ),
            ),
            TextField(
              controller: _signatureTextController,
              decoration: const InputDecoration(labelText: "Signature texte"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _openSignaturePad,
              child: const Text("Signer manuellement"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Annuler"),
        ),
        TextButton(
          onPressed: () {
            widget.onConfirmed(
              _signatureTextController.text.trim(),
              _style,
              _manualSignatureBase64,
            );
            Navigator.of(context).pop();
          },
          child: const Text("Valider"),
        ),
      ],
    );
  }
}
