import 'package:flutter/material.dart';
import 'package:kinksme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:kinksme/themes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Choisissez votre thème",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile<ThemeData>(
            title: const Text("Thème Sombre"),
            value: elegantDarkTheme,
            groupValue: themeProvider.currentTheme,
            onChanged: (value) {
              if (value != null) {
                themeProvider.switchTheme(value);
              }
            },
          ),
          RadioListTile<ThemeData>(
            title: const Text("Thème Clair"),
            value: elegantLightTheme,
            groupValue: themeProvider.currentTheme,
            onChanged: (value) {
              if (value != null) {
                themeProvider.switchTheme(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
