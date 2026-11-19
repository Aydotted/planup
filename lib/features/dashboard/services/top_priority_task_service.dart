import '../../tasks/domain/entities/task.dart';

class TopPriorityTaskService {
  static Task? getTopPriorityTask(List<Task> tasks) {
    final available = tasks
        .where((task) => !task.isCompleted && !task.deleted && !task.isArchived)
        .toList();

    if (available.isEmpty) {
      return null;
    }

    available.sort((a, b) {
      if (a.dueDate == null && b.dueDate != null) {
        return 1;
      }

      if (a.dueDate != null && b.dueDate == null) {
        return -1;
      }

      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      }

      return 0;
    });

    return available.first;
  }
}
