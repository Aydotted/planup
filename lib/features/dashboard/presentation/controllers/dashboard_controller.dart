import 'package:flutter/material.dart';

import '../../../tasks/presentation/controllers/task_controller.dart';
import '../../../calendar/presentation/controllers/calendar_controller.dart';

import '../../../../shared/services/habit_streak_engine.dart';

import '../../../tasks/domain/entities/task.dart';
import '../../../shifts/domain/entities/shift.dart';

class DashboardController extends ChangeNotifier {
  final TaskController taskController;
  final CalendarController calendarController;

  DashboardController({
    required this.taskController,
    required this.calendarController,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await taskController.init();
    await calendarController.init();

    _isLoading = false;
    notifyListeners();
  }

  List<Task> get pinnedTasks =>
      taskController.tasks.where((t) => t.isPinned && !t.deleted).toList();

  List<Task> get priorityTasks =>
      taskController.tasks.where((t) => t.priority == 3 && !t.deleted).toList();

  List<Task> get todayTasks {
    final now = DateTime.now();

    return taskController.tasks.where((t) {
      final d = t.dueDate;

      return d != null &&
          d.year == now.year &&
          d.month == now.month &&
          d.day == now.day &&
          !t.deleted &&
          !t.isArchived;
    }).toList();
  }

  List<Task> get overdueTasks {
    final now = DateTime.now();

    return taskController.tasks.where((t) {
      final d = t.dueDate;

      return d != null && d.isBefore(now) && !t.isCompleted && !t.deleted;
    }).toList();
  }

  List<Task> get upcomingTasks {
    final now = DateTime.now();

    return taskController.tasks.where((t) {
      final d = t.dueDate;

      return d != null && d.isAfter(now) && !t.deleted && !t.isArchived;
    }).toList();
  }

  double get weeklyProductivity {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final weeklyTasks = taskController.tasks.where((t) {
      final d = t.dueDate;

      return d != null && d.isAfter(weekAgo) && d.isBefore(now);
    }).toList();

    if (weeklyTasks.isEmpty) {
      return 0;
    }

    final completed = weeklyTasks.where((t) => t.isCompleted).length;

    return completed / weeklyTasks.length;
  }

  int get habitStreak {
    try {
      final engine = HabitStreakEngine();

      final completedTasks = taskController.tasks
          .where((t) => t.isCompleted)
          .toList();
      if (completedTasks.isEmpty) {
        return 0;
      }
      completedTasks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return engine.calculateStreak(completedTasks.first.updatedAt);
    } catch (_) {
      return 0;
    }
  }

  List<Shift?> get nextWeekShifts {
    return <Shift?>[];
  }
}
