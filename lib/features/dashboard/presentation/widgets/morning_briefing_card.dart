import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../habits/presentation/controllers/habit_controller.dart';
import '../../../tasks/presentation/controllers/task_controller.dart';

import '../../services/burnout_detection_service.dart';
import '../../services/burnout_input.dart';
import '../../services/focus_score_service.dart';
import '../../services/forecast_input.dart';
import '../../services/habit_shift_correlation_service.dart';
import '../../services/morning_briefing_service.dart';
import '../../services/priority_task_insight_service.dart';
import '../../services/productivity_forecast_service.dart';
import '../../services/recovery_score_service.dart';
import '../../services/recovery_trend_service.dart';
import '../../services/task_shift_correlation_service.dart';
import '../../services/top_priority_task_service.dart';
import '../../services/top_productive_shift_service.dart';

class MorningBriefingCard extends StatelessWidget {
  const MorningBriefingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();

    final topTask = TopPriorityTaskService.getTopPriorityTask(
      taskController.tasks,
    );

    final taskInsight = PriorityTaskInsightService.analyse(topTask);

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

    final productivity = TopProductiveShiftService.analyse(taskRates);

    final habitRates = HabitShiftCorrelationService.completionRates(
      habits: habitProvider.allHabits,
      shifts: shifts,
    );

    final debt = RecoveryScoreService.calculateRecoveryDebt(shifts);

    final recovery = RecoveryScoreService.analyse(shifts);

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

    final briefing = MorningBriefingService.generate(
      shift: nextShift.shiftType,
      recoveryStatus: recovery.status,
      burnoutRisk: burnout.risk,
      dueToday: taskController.todayCount,
      overdue: taskController.overdueCount,
      forecastCompletion: forecast.expectedTaskRate,
    );

    final focusScore = FocusScoreService.calculate(
      burnoutRisk: burnout.risk,
      recoveryDebt: debt,
      forecastRate: forecast.expectedTaskRate,
      taskCompletionRate: taskController.weeklyCompletionRate,
      habitCompletionRate: habitRate,
    );

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (briefing.highBurnoutRisk)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '⚠ High Burnout Risk Detected',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            if (briefing.hasOverdueTasks)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '⚠ ${briefing.overdue} Overdue Task(s)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            Text(
              'Focus Score: $focusScore/100',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (taskInsight != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Priority Task',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(taskInsight.title),
                    Text(taskInsight.dueText),
                    Text('Risk: ${taskInsight.risk}'),
                    Text(taskInsight.recommendation),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            Text('Today\'s Shift: ${briefing.shift}'),

            Text('Recovery Status: ${briefing.recoveryStatus}'),

            Text('Burnout Risk: ${briefing.burnoutRisk}'),

            Text('Tasks Due Today: ${briefing.dueToday}'),

            Text('Overdue Tasks: ${briefing.overdue}'),

            Text(
              'Expected Productivity: '
              '${briefing.expectedProductivity}%',
            ),

            Text(
              'Most Productive Shift: '
              '${productivity.bestShift}',
            ),

            Text(
              'Least Productive Shift: '
              '${productivity.worstShift}',
            ),

            const Divider(height: 24),

            const Text(
              'Today\'s Focus',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(briefing.focus),

            const SizedBox(height: 12),

            const Text(
              'Recovery Recommendation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(briefing.recoveryRecommendation),
          ],
        ),
      ),
    );
  }
}
