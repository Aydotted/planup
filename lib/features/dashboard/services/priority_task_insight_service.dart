import '../../tasks/domain/entities/task.dart';

import 'priority_task_insight_result.dart';

class PriorityTaskInsightService {
  static PriorityTaskInsightResult? analyse(Task? task) {
    if (task == null) {
      return null;
    }

    String dueText = 'No due date';
    String risk = 'Low';
    String recommendation = 'Complete when practical.';

    if (task.dueDate != null) {
      final days = task.dueDate!.difference(DateTime.now()).inDays;

      if (days <= 0) {
        dueText = 'Due Today';
        risk = 'High';

        recommendation = 'Complete before midday.';
      } else if (days <= 2) {
        dueText = 'Due in $days day(s)';
        risk = 'Moderate';

        recommendation = 'Schedule time today.';
      } else {
        dueText = 'Due in $days day(s)';
      }
    }

    return PriorityTaskInsightResult(
      title: task.title,
      dueText: dueText,
      risk: risk,
      recommendation: recommendation,
    );
  }
}
