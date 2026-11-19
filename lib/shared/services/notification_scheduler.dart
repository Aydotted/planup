import '../../features/tasks/domain/entities/task.dart';
import 'notification_service.dart';

class NotificationScheduler {
  // ------------------------------------------------------------
  // SCHEDULE A TASK (MINIMAL VERSION)
  // ------------------------------------------------------------
  Future<void> schedule(Task task) async {
    if (task.dueDate == null) return;

    // Cancel old reminder
    await NotificationService.cancelReminder(task.id.hashCode);

    // If no recurrence → schedule once
    // ignore: unnecessary_null_comparison
    if (task.recurrence == null ||
        task.recurrence.isEmpty ||
        task.recurrence == 'none') {
      await _scheduleSingle(task);
      return;
    }

    // Minimal recurrence scheduling
    await _scheduleRecurring(task);
  }

  // ------------------------------------------------------------
  // CANCEL A TASK
  // ------------------------------------------------------------
  Future<void> cancel(String taskId) async {
    await NotificationService.cancelReminder(taskId.hashCode);
  }

  // ------------------------------------------------------------
  // SINGLE REMINDER
  // ------------------------------------------------------------
  Future<void> _scheduleSingle(Task task) async {
    final reminderTime = task.dueDate!.subtract(
      Duration(minutes: task.reminderMinutesBefore),
    );

    await NotificationService.scheduleReminder(
      id: task.id.hashCode,
      title: task.title,
      body: 'Task due soon',
      dateTime: reminderTime,
    );
  }

  // ------------------------------------------------------------
  // MINIMAL RECURRING REMINDERS (OPTION C)
  // ------------------------------------------------------------
  Future<void> _scheduleRecurring(Task task) async {
    DateTime next = task.dueDate!;

    switch (task.recurrence) {
      case 'daily':
        next = next.add(const Duration(days: 1));
        break;

      case 'weekly':
        next = next.add(const Duration(days: 7));
        break;

      case 'monthly':
        next = next.add(const Duration(days: 30));
        break;

      default:
        next = next;
        break;
    }

    final reminderTime = next.subtract(
      Duration(minutes: task.reminderMinutesBefore),
    );

    await NotificationService.scheduleReminder(
      id: task.id.hashCode,
      title: '${task.title} (${task.recurrence})',
      body: 'Task due soon',
      dateTime: reminderTime,
    );
  }
}
