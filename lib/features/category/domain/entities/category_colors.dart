import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:planup_fixed_new/features/category/domain/entities/category.dart';

class CategoryColors {
  /// Default category colors stored as INT values (not Color objects)
  static final Map<String, int> defaultColors = {
    // Work Shifts
    'Long Day': Colors.blue.toARGB32(),
    'Early': Colors.lightBlue.toARGB32(),
    'Late': Colors.orange.toARGB32(),
    'Night': Colors.purple.toARGB32(),
    'Twilight': Colors.teal.toARGB32(),

    // Locum / Extra / Overtime
    'Locum': Colors.amber.toARGB32(),
    'Overtime': Colors.red.toARGB32(),
    'Extra Shift': Colors.deepOrange.toARGB32(),

    // Holidays
    'Annual Leave': Colors.green.toARGB32(),
    'Study Leave': Colors.lime.toARGB32(),
    'Sick Leave': Colors.yellow.toARGB32(),

    // Bank Holiday
    'Bank Holiday': Colors.grey.toARGB32(),

    // Fallback
    'General': Colors.indigo.toARGB32(),
  };

  /// Returns the correct color INT for a category name
  static int getColorForCategory(String categoryName) {
    final customBox = Hive.box<Category>('categories');

    // Check custom categories first
    final custom = customBox.values.firstWhere(
      (c) => c.name == categoryName,
      orElse: () => Category(
        id: 'none',
        name: 'NONE',
        color: Colors.transparent.toARGB32(),
        iconCodePoint: Icons.label.codePoint,
        abbreviation: 'WRK',
      ),
    );

    if (custom.name != 'NONE') {
      return custom.color;
    }

    // Fallback to default
    return defaultColors[categoryName] ?? defaultColors['General']!;
  }
}
