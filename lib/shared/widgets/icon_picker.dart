import 'package:flutter/material.dart';

class IconPicker extends StatelessWidget {
  final int selectedIcon;
  final Function(int) onIconSelected;

  IconPicker({required this.selectedIcon, required this.onIconSelected});

  final List<IconData> availableIcons = [
    Icons.work,
    Icons.school,
    Icons.fitness_center,
    Icons.shopping_cart,
    Icons.home,
    Icons.star,
    Icons.book,
    Icons.favorite,
    Icons.alarm,
    Icons.calendar_today,
    Icons.check_circle,
    Icons.lightbulb,
    Icons.music_note,
    Icons.pets,
    Icons.travel_explore,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: availableIcons.map((icon) {
        final codePoint = icon.codePoint;
        final isSelected = codePoint == selectedIcon;

        return GestureDetector(
          onTap: () => onIconSelected(codePoint),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                  : Colors.grey.shade200,
            ),
            child: Icon(
              icon,
              size: 28,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade600,
            ),
          ),
        );
      }).toList(),
    );
  }
}
