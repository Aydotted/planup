import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'theme_settings.g.dart';

@HiveType(typeId: 6)
class ThemeSettings extends HiveObject {
  @HiveField(0)
  ThemeMode themeMode;

  @HiveField(1)
  int accentColorValue;

  ThemeSettings({
    this.themeMode = ThemeMode.system,
    this.accentColorValue = 0xFF2196F3, // default blue
  });

  Color get accentColor => Color(accentColorValue);

  void setAccentColor(Color color) {
    accentColorValue = color.value;
    save();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    save();
  }
}
