import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 8)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<DateTime> completedDates;

  @HiveField(3)
  int streak;

  @HiveField(4)
  int longestStreak;

  @HiveField(5)
  DateTime? lastCompletedDate;

  @HiveField(6)
  int color;

  @HiveField(7)
  int iconCode;

  Habit({
    required this.id,
    required this.name,
    this.completedDates = const [],
    this.streak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
    this.color = 0xFF2196F3, // default blue
    this.iconCode = 0xE87C, // default check icon
  });
}
