import 'package:hive/hive.dart';

part 'shift.g.dart';

@HiveType(typeId: 5)
class Shift extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String categoryId;

  @HiveField(2)
  DateTime? startTime;

  @HiveField(3)
  DateTime? endTime;

  @HiveField(4)
  String notes;

  @HiveField(5)
  String shiftType;

  @HiveField(6)
  int? colorValue;

  @HiveField(7)
  String? abbreviation;

  @HiveField(8)
  String id;

  @HiveField(9)
  bool? notificationsEnabled;

  @HiveField(10)
  int? reminderMinutesBefore;

  Shift({
    required this.id,
    required this.date,
    required this.categoryId,
    required this.shiftType,
    this.startTime,
    this.endTime,
    this.notes = '',
    this.colorValue,
    this.abbreviation,
    this.notificationsEnabled = true,
    this.reminderMinutesBefore = 60,
  });

  Duration? get duration {
    if (startTime == null || endTime == null) {
      return null;
    }

    return endTime!.difference(startTime!);
  }

  bool get hasTimeRange => startTime != null && endTime != null;
}
