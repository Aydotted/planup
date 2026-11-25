import 'package:hive/hive.dart';

import 'subtask.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  DateTime? dueDate;

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  bool isArchived;

  @HiveField(8)
  bool isPinned;

  @HiveField(9)
  int priority;

  @HiveField(10)
  int color;

  @HiveField(11)
  List<String> tags;

  @HiveField(12)
  List<Subtask> subtasks;

  @HiveField(13)
  String? categoryId;

  @HiveField(14)
  int categoryColor;

  @HiveField(15)
  int categoryIconCodePoint;

  @HiveField(16)
  String recurrence;

  @HiveField(17)
  int reminderMinutesBefore;

  @HiveField(18)
  List<String> attachments;

  @HiveField(19)
  String? notes;

  @HiveField(20)
  double progress;

  @HiveField(21)
  String? categoryName;

  @HiveField(22)
  bool deleted;

  @HiveField(23)
  DateTime? startTime;

  @HiveField(24)
  DateTime? endTime;

  @HiveField(25)
  String? recurrenceSeriesId;

  @HiveField(99)
  int? notificationId;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
    this.isCompleted = false,
    this.isArchived = false,
    this.isPinned = false,
    this.priority = 1,
    this.color = 0xFF2196F3,
    this.tags = const [],
    this.subtasks = const [],
    this.categoryId,
    this.categoryColor = 0xFF2196F3,
    this.categoryIconCodePoint = 0xE87C,
    this.recurrence = 'none',
    this.reminderMinutesBefore = 0,
    this.attachments = const [],
    this.notes,
    this.progress = 0.0,
    this.categoryName,
    this.deleted = false,
    this.startTime,
    this.endTime,
    this.recurrenceSeriesId,
    this.notificationId,
  });

  bool get completed => isCompleted;
  bool get isOverdue {
    if (dueDate == null || isCompleted) {
      return false;
    }

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);

    return taskDate.isBefore(today);
  }

  bool get isDueToday {
    if (dueDate == null) {
      return false;
    }

    final today = DateTime.now();

    return dueDate!.year == today.year &&
        dueDate!.month == today.month &&
        dueDate!.day == today.day;
  }

  bool get isUpcoming {
    if (dueDate == null || isCompleted) {
      return false;
    }

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);

    return taskDate.isAfter(today);
  }

  void calculateProgress() {
    if (subtasks.isEmpty) {
      progress = isCompleted ? 1.0 : 0.0;
      return;
    }

    final completedCount = subtasks.where((s) => s.isCompleted).length;

    progress = completedCount / subtasks.length;
  }

  bool get isRecurring {
    return recurrence != 'none';
  }

  Task copyWith({
    String? title,
    String? description,
    DateTime? updatedAt,
    DateTime? dueDate,
    bool? isCompleted,
    bool? isArchived,
    bool? isPinned,
    int? priority,
    int? color,
    List<String>? tags,
    List<Subtask>? subtasks,
    String? categoryId,
    int? categoryColor,
    int? categoryIconCodePoint,
    String? recurrence,
    int? reminderMinutesBefore,
    List<String>? attachments,
    String? notes,
    double? progress,
    String? categoryName,
    bool? deleted,
    DateTime? startTime,
    DateTime? endTime,
    String? recurrenceSeriesId,
    int? notificationId,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isArchived: isArchived ?? this.isArchived,
      isPinned: isPinned ?? this.isPinned,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      tags: tags ?? this.tags,
      subtasks: subtasks ?? this.subtasks,
      categoryId: categoryId ?? this.categoryId,
      categoryColor: categoryColor ?? this.categoryColor,
      categoryIconCodePoint:
          categoryIconCodePoint ?? this.categoryIconCodePoint,
      recurrence: recurrence ?? this.recurrence,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      attachments: attachments ?? this.attachments,
      notes: notes ?? this.notes,
      progress: progress ?? this.progress,
      categoryName: categoryName ?? this.categoryName,
      deleted: deleted ?? this.deleted,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      recurrenceSeriesId: recurrenceSeriesId ?? this.recurrenceSeriesId,
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
