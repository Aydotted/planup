import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: theme.primary,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ------------------------------------------------------------
          // PROFILE SETTINGS
          // ------------------------------------------------------------
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            subtitle: const Text("Edit your name, photo, and preferences"),
            onTap: () {
              Navigator.pushNamed(context, "/profile");
            },
          ),
          const Divider(),

          // ------------------------------------------------------------
          // THEME SETTINGS
          // ------------------------------------------------------------
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text("Theme"),
            subtitle: const Text("Light, dark, and accent colours"),
            onTap: () {
              Navigator.pushNamed(context, "/themeSettings");
            },
          ),
          const Divider(),

          // ------------------------------------------------------------
          // CATEGORY MANAGEMENT
          // ------------------------------------------------------------
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text("Categories"),
            subtitle: const Text("Manage task categories"),
            onTap: () {
              Navigator.pushNamed(context, "/categoryManagement");
            },
          ),
          const Divider(),

          // ------------------------------------------------------------
          // ABOUT
          // ------------------------------------------------------------
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About PlanUp"),
            subtitle: const Text("Version 1.0.0"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
