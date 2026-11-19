import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int color;

  @HiveField(3)
  int iconCodePoint;

  @HiveField(4)
  String abbreviation;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.iconCodePoint,
    required this.abbreviation,
  });
}
