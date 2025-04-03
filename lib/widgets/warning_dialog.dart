import 'package:flutter/material.dart';

Future<void> showWarningDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // L'utilisateur doit appuyer sur "OK" pour fermer
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Avertissement',
          style: TextStyle(color: Color.fromARGB(255, 175, 3, 3)),
        ),
        content: const SingleChildScrollView(
          child: Text(
            "Privilégions les échanges authentiques et respectueux. Ne partagez pas vos coordonnées ni d'argent ! Si vous avez des fonds à dépenser, soutenez plutôt Kink’s Me pour que cette communauté continue de grandir !",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
