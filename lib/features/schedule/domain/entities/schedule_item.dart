import 'package:hive/hive.dart';

part 'schedule_item.g.dart';

@HiveType(typeId: 20)
enum ScheduleItemType {
  @HiveField(0)
  task,

  @HiveField(1)
  reminder,

  @HiveField(2)
  subscription,

  @HiveField(3)
  personalEvent,
}

@HiveType(typeId: 21)
class ScheduleItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ScheduleItemType type;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String notes;

  @HiveField(4)
  final String subtype;

  @HiveField(5)
  final DateTime dateTime;

  @HiveField(6)
  final bool completed;

  @HiveField(7)
  final bool notificationsEnabled;

  @HiveField(8)
  final int reminderMinutesBefore;

  @HiveField(9)
  final int? notificationId;

  @HiveField(10)
  final bool? recurring;

  @HiveField(11)
  final String? recurrenceType;

  @HiveField(12)
  final String? recurrenceSeriesId;

  ScheduleItem({
    required this.id,
    required this.type,
    required this.title,
    required this.notes,
    required this.subtype,
    required this.dateTime,
    this.completed = false,
    this.notificationsEnabled = true,
    this.reminderMinutesBefore = 30,
    this.notificationId,
    this.recurring = false,
    this.recurrenceType = 'none',
    this.recurrenceSeriesId,
  });
}
