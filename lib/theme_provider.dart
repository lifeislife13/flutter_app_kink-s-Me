import 'package:flutter/material.dart';
import 'themes.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = elegantDarkTheme; // Par défaut, le thème sombre

  ThemeData get currentTheme => _currentTheme;

  void switchTheme(ThemeData newTheme) {
    _currentTheme = newTheme;
    notifyListeners();
  }

  getTheme() {}
}
