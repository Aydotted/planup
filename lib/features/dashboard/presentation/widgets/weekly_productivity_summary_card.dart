import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../tasks/presentation/controllers/task_controller.dart';
import '../../../habits/presentation/controllers/habit_controller.dart';

import '../../services/burnout_detection_service.dart';
import '../../services/burnout_input.dart';
import '../../services/recovery_score_service.dart';
import '../../services/recovery_trend_service.dart';
import '../../services/weekly_productivity_summary_service.dart';

class WeeklyProductivitySummaryCard extends StatelessWidget {
  const WeeklyProductivitySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();

    final habitProvider = context.watch<HabitProvider>();

    final calendarController = context.watch<CalendarController>();

    final debt = RecoveryScoreService.calculateRecoveryDebt(
      calendarController.shifts,
    );

    final trend = RecoveryTrendService.analyse(calendarController.shifts);

    final totalHabits = habitProvider.allHabits.length;

    final completedToday = habitProvider.allHabits.where((habit) {
      final today = DateTime.now();

      return habit.completedDates.any(
        (date) =>
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day,
      );
    }).length;

    final habitRate = BurnoutDetectionService.habitCompletionRate(
      totalHabits: totalHabits,
      completedToday: completedToday,
    );

    final burnout = BurnoutDetectionService.evaluate(
      input: BurnoutInput(
        recoveryDebt: debt,
        recoveryTrend: trend.trend,
        monthlyLoad: trend.monthlyLoad,
        taskCompletionRate: taskController.weeklyCompletionRate,
        habitCompletionRate: habitRate,
      ),
    );

    final summary = WeeklyProductivitySummaryService.analyse(
      completedTasks: taskController.completedCount,
      totalTasks: taskController.totalCount,
      recoveryTrend: trend.trend,
      burnoutRisk: burnout.risk,
      monthlyLoad: trend.monthlyLoad,
    );

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Productivity Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              'Tasks Completed: '
              '${summary.tasksCompleted}/${summary.totalTasks}',
            ),

            const SizedBox(height: 6),

            Text(
              'Completion Rate: '
              '${(summary.completionRate * 100).round()}%',
            ),

            const SizedBox(height: 6),

            Text(
              'Recovery Trend: '
              '${summary.recoveryTrend}',
            ),

            const SizedBox(height: 6),

            Text(
              'Burnout Risk: '
              '${summary.burnoutRisk}',
            ),

            const SizedBox(height: 6),

            Text(
              'Monthly Load: '
              '${summary.monthlyLoad}',
            ),

            const Divider(height: 24),

            Text(
              'Focus Next Week',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(summary.focus),
          ],
        ),
      ),
    );
  }
}
