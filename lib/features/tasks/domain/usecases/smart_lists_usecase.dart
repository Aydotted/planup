import '../entities/task.dart';

class SmartListsUseCase {
  final List<Task> tasks;

  SmartListsUseCase(this.tasks);

  // ------------------------------------------------------------
  // TODAY TASKS
  // ------------------------------------------------------------
  List<Task> today() {
    final now = DateTime.now();
    return tasks.where((t) {
      final d = t.dueDate;
      return d != null &&
          d.year == now.year &&
          d.month == now.month &&
          d.day == now.day &&
          !t.deleted &&
          !t.isArchived;
    }).toList();
  }

  // ------------------------------------------------------------
  // OVERDUE TASKS
  // ------------------------------------------------------------
  List<Task> overdue() {
    final now = DateTime.now();
    return tasks.where((t) {
      final d = t.dueDate;
      return d != null && d.isBefore(now) && !t.isCompleted && !t.deleted;
    }).toList();
  }

  // ------------------------------------------------------------
  // UPCOMING TASKS
  // ------------------------------------------------------------
  List<Task> upcoming() {
    final now = DateTime.now();
    return tasks.where((t) {
      final d = t.dueDate;
      return d != null && d.isAfter(now) && !t.deleted && !t.isArchived;
    }).toList();
  }

  // ------------------------------------------------------------
  // PINNED TASKS
  // ------------------------------------------------------------
  List<Task> pinned() {
    return tasks.where((t) => t.isPinned && !t.deleted).toList();
  }

  // ------------------------------------------------------------
  // COMPLETED TASKS
  // ------------------------------------------------------------
  List<Task> completed() {
    return tasks.where((t) => t.isCompleted && !t.deleted).toList();
  }

  // ------------------------------------------------------------
  // PRIORITY TASKS (High priority only)
  // ------------------------------------------------------------
  List<Task> priority() {
    return tasks.where((t) => t.priority == 3 && !t.deleted).toList();
  }

  // ------------------------------------------------------------
  // TASKS WITHOUT A DATE
  // ------------------------------------------------------------
  List<Task> noDate() {
    return tasks.where((t) => t.dueDate == null && !t.deleted).toList();
  }

  // ------------------------------------------------------------
  // TASKS FOR A SPECIFIC DATE
  // ------------------------------------------------------------
  List<Task> forDate(DateTime date) {
    return tasks.where((t) {
      final d = t.dueDate;
      return d != null &&
          d.year == date.year &&
          d.month == date.month &&
          d.day == date.day &&
          !t.deleted &&
          !t.isArchived;
    }).toList();
  }

  // ------------------------------------------------------------
  // TASKS FOR A WEEK
  // ------------------------------------------------------------
  List<Task> forWeek(DateTime startOfWeek) {
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return tasks.where((t) {
      final d = t.dueDate;
      return d != null &&
          d.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          d.isBefore(endOfWeek.add(const Duration(days: 1))) &&
          !t.deleted &&
          !t.isArchived;
    }).toList();
  }

  // ------------------------------------------------------------
  // TASKS FOR A MONTH
  // ------------------------------------------------------------
  List<Task> forMonth(DateTime month) {
    return tasks.where((t) {
      final d = t.dueDate;
      return d != null &&
          d.year == month.year &&
          d.month == month.month &&
          !t.deleted &&
          !t.isArchived;
    }).toList();
  }

  // ------------------------------------------------------------
  // WEEKLY PRODUCTIVITY SCORE
  // ------------------------------------------------------------
  double weeklyProductivity() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final weeklyTasks = tasks.where((t) {
      final d = t.dueDate;
      return d != null && d.isAfter(weekAgo) && d.isBefore(now);
    }).toList();

    if (weeklyTasks.isEmpty) return 0;

    final completedCount = weeklyTasks.where((t) => t.isCompleted).length;
    return completedCount / weeklyTasks.length;
  }
}
