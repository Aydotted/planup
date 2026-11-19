import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/controllers/theme_controller.dart';

class ThemeCustomisationScreen extends StatelessWidget {
  const ThemeCustomisationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Customisation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ColorPickerTile(
            title: 'Accent Colour',
            current: controller.accentColor,
            onTap: () => _pickColor(context, controller.setAccentColor),
          ),
        ],
      ),
    );
  }

  void _pickColor(BuildContext context, Function(Color) onSelected) {
    final colours = [
      Colors.indigo,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.grey,
      Colors.black,
    ];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Choose Colour'),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colours.map((c) {
            return GestureDetector(
              onTap: () {
                onSelected(c);
                Navigator.pop(context);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ColorPickerTile extends StatelessWidget {
  final String title;
  final Color current;
  final VoidCallback onTap;

  const _ColorPickerTile({
    required this.title,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: current),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
