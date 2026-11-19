import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  Color accentColor = Colors.blue;
  Color cardColor = Colors.white;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setAccentColor(Color color) {
    accentColor = color;
    notifyListeners();
  }

  void updateCardColor(Color color) {
    cardColor = color;
    notifyListeners();
  }
}
