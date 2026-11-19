import 'package:flutter/material.dart';

class TagChips extends StatelessWidget {
  final List<String> tags;

  const TagChips({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags.map((tag) {
        return Chip(
          label: Text(tag),
          backgroundColor: Colors.blue.withValues(alpha: 0.15),
          labelStyle: const TextStyle(color: Colors.blue),
        );
      }).toList(),
    );
  }
}
