import 'package:flutter/material.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Theme Settings")),
      body: const Center(
        child: Text(
          "Theme options will go here.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
