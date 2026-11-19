import '../../features/tasks/domain/entities/task.dart';

class RecurrenceEngine {
  /// Returns a new due date based on the recurrence rule.
  /// If recurrence is null or empty, returns null.
  DateTime? getNextDueDate(Task task) {
    // ignore: unnecessary_null_comparison
    if (task.recurrence == null || task.recurrence.isEmpty) {
      return null;
    }

    final recurrence = task.recurrence.toLowerCase();
    final due = task.dueDate;

    if (due == null) return null;

    switch (recurrence) {
      case 'daily':
        return due.add(const Duration(days: 1));

      case 'weekly':
        return due.add(const Duration(days: 7));

      case 'monthly':
        return DateTime(due.year, due.month + 1, due.day, due.hour, due.minute);

      default:
        return null;
    }
  }

  /// Applies recurrence when a task is completed.
  /// Returns true if the task was updated.
  bool applyRecurrence(Task task) {
    final next = getNextDueDate(task);

    if (next == null) return false;

    task.dueDate = next;
    task.isCompleted = false;
    task.updatedAt = DateTime.now();

    return true;
  }
}
