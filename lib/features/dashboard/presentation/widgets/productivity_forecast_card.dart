import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../habits/presentation/controllers/habit_controller.dart';
import '../../../tasks/presentation/controllers/task_controller.dart';

import '../../services/burnout_detection_service.dart';
import '../../services/burnout_input.dart';
import '../../services/forecast_input.dart';
import '../../services/habit_shift_correlation_service.dart';
import '../../services/productivity_forecast_service.dart';
import '../../services/recovery_score_service.dart';
import '../../services/recovery_trend_service.dart';
import '../../services/task_shift_correlation_service.dart';

class ProductivityForecastCard extends StatelessWidget {
  const ProductivityForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();

    final habitProvider = context.watch<HabitProvider>();

    final calendarController = context.watch<CalendarController>();

    final shifts = calendarController.shifts;

    final nextShift = ProductivityForecastService.nextShift(shifts);

    if (nextShift == null) {
      return const SizedBox.shrink();
    }

    final taskRates = TaskShiftCorrelationService.completionRates(
      tasks: taskController.tasks,
      shifts: shifts,
    );

    final habitRates = HabitShiftCorrelationService.completionRates(
      habits: habitProvider.allHabits,
      shifts: shifts,
    );

    final debt = RecoveryScoreService.calculateRecoveryDebt(shifts);

    final trend = RecoveryTrendService.analyse(shifts);

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

    final forecast = ProductivityForecastService.forecast(
      input: ForecastInput(
        upcomingShift: nextShift.shiftType,
        taskRates: taskRates,
        habitRates: habitRates,
        burnoutRisk: burnout.risk,
        recoveryTrend: trend.trend,
        monthlyLoad: trend.monthlyLoad,
        recoveryDebt: debt,
      ),
    );

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tomorrow\'s Forecast',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text('Upcoming Shift: ${nextShift.shiftType}'),

            const SizedBox(height: 6),

            Text(
              'Expected Task Completion: '
              '${(forecast.expectedTaskRate * 100).round()}%',
            ),

            const SizedBox(height: 6),

            Text(
              'Expected Habit Success: '
              '${(forecast.expectedHabitRate * 100).round()}%',
            ),

            const SizedBox(height: 6),

            Text(
              'Expected Burnout Risk: '
              '${forecast.expectedBurnout}',
            ),

            const SizedBox(height: 6),

            Text(
              'Recovery Trend: '
              '${trend.trend}',
            ),

            const SizedBox(height: 6),

            Text(
              'Monthly Load: '
              '${trend.monthlyLoad}',
            ),

            const Divider(height: 24),

            const Text(
              'Recommended Action',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(forecast.recommendation),
          ],
        ),
      ),
    );
  }
}
