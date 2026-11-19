import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'category_icon.g.dart';

@HiveType(typeId: 4) // ⭐
class CategoryIcon {
  @HiveField(0)
  String name;

  @HiveField(1)
  int iconCodePoint;

  CategoryIcon({required this.name, required this.iconCodePoint});

  IconData get icon => Icons.category;

  static final List<CategoryIcon> defaultIcons = [
    CategoryIcon(name: 'Work', iconCodePoint: Icons.work.codePoint),
    CategoryIcon(name: 'Home', iconCodePoint: Icons.home.codePoint),
    CategoryIcon(name: 'School', iconCodePoint: Icons.school.codePoint),
    CategoryIcon(
      name: 'Fitness',
      iconCodePoint: Icons.fitness_center.codePoint,
    ),
    CategoryIcon(
      name: 'Shopping',
      iconCodePoint: Icons.shopping_cart.codePoint,
    ),
    CategoryIcon(name: 'Travel', iconCodePoint: Icons.flight.codePoint),
    CategoryIcon(
      name: 'Health',
      iconCodePoint: Icons.health_and_safety.codePoint,
    ),
    CategoryIcon(name: 'Music', iconCodePoint: Icons.music_note.codePoint),
    CategoryIcon(name: 'Food', iconCodePoint: Icons.fastfood.codePoint),
    CategoryIcon(name: 'General', iconCodePoint: Icons.category.codePoint),
  ];
}
