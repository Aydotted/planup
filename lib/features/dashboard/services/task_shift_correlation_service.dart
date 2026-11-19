import '../../shifts/domain/entities/shift.dart';
import '../../tasks/domain/entities/task.dart';

import 'task_shift_stat.dart';

class TaskShiftCorrelationService {
  static String productivityInsight(Map<String, double> rates) {
    if (rates.isEmpty) {
      return 'Not enough data available.';
    }

    final sorted = rates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final best = sorted.first;
    final worst = sorted.last;

    if (best.key == worst.key) {
      return 'More data is needed before meaningful patterns can be identified.';
    }

    final difference = ((best.value - worst.value) * 100).round();

    return '${best.key} shifts currently outperform '
        '${worst.key} shifts by approximately '
        '$difference%.';
  }

  static Map<String, double> completionRates({
    required List<Task> tasks,
    required List<Shift> shifts,
  }) {
    final Map<String, int> totalTasks = {};
    final Map<String, int> completedTasks = {};

    for (final task in tasks) {
      if (task.dueDate == null) {
        continue;
      }

      final matchingShift = shifts
          .where((shift) {
            return shift.date.year == task.dueDate!.year &&
                shift.date.month == task.dueDate!.month &&
                shift.date.day == task.dueDate!.day;
          })
          .cast<Shift?>()
          .firstWhere((_) => true, orElse: () => null);

      if (matchingShift == null) {
        continue;
      }

      final type = matchingShift.shiftType;

      totalTasks[type] = (totalTasks[type] ?? 0) + 1;

      if (task.isCompleted) {
        completedTasks[type] = (completedTasks[type] ?? 0) + 1;
      }
    }

    final result = <String, double>{};

    totalTasks.forEach((shiftType, count) {
      final completed = completedTasks[shiftType] ?? 0;

      result[shiftType] = count == 0 ? 0 : completed / count;
    });

    return result;
  }

  static List<TaskShiftStat> shiftStatistics({
    required List<Task> tasks,
    required List<Shift> shifts,
  }) {
    final Map<String, int> totalTasks = {};
    final Map<String, int> completedTasks = {};

    for (final task in tasks) {
      if (task.dueDate == null) {
        continue;
      }

      final matchingShift = shifts
          .where((shift) {
            return shift.date.year == task.dueDate!.year &&
                shift.date.month == task.dueDate!.month &&
                shift.date.day == task.dueDate!.day;
          })
          .cast<Shift?>()
          .firstWhere((_) => true, orElse: () => null);

      if (matchingShift == null) {
        continue;
      }

      final type = matchingShift.shiftType;

      totalTasks[type] = (totalTasks[type] ?? 0) + 1;

      if (task.isCompleted) {
        completedTasks[type] = (completedTasks[type] ?? 0) + 1;
      }
    }

    return totalTasks.entries.map((entry) {
      return TaskShiftStat(
        shiftType: entry.key,
        totalTasks: entry.value,
        completedTasks: completedTasks[entry.key] ?? 0,
      );
    }).toList();
  }
}
