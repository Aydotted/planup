import 'package:hive/hive.dart';

part 'shift_template.g.dart';

@HiveType(typeId: 7)
class ShiftTemplate extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String abbreviation;

  @HiveField(3)
  int colourValue;

  @HiveField(4)
  int startHour;

  @HiveField(5)
  int startMinute;

  @HiveField(6)
  int endHour;

  @HiveField(7)
  int endMinute;

  ShiftTemplate({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.colourValue,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
  });
}
