import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/notifications/smart_notification_scheduler.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../habits/presentation/controllers/habit_controller.dart';
import '../../../tasks/presentation/controllers/task_controller.dart';

import '../../services/burnout_detection_service.dart';
import '../../services/burnout_input.dart';
import '../../services/habit_shift_correlation_service.dart';
import '../../services/recommendation_input.dart';
import '../../services/recommendation_service.dart';
import '../../services/recovery_score_service.dart';
import '../../services/recovery_trend_service.dart';
import '../../services/task_shift_correlation_service.dart';

class ScheduledNotificationsCard extends StatelessWidget {
  const ScheduledNotificationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();

    final calendarController = context.watch<CalendarController>();

    final habitProvider = context.watch<HabitProvider>();

    final taskRates = TaskShiftCorrelationService.completionRates(
      tasks: taskController.tasks,
      shifts: calendarController.shifts,
    );

    final habitRates = HabitShiftCorrelationService.completionRates(
      habits: habitProvider.allHabits,
      shifts: calendarController.shifts,
    );

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

    final recommendations = RecommendationService.generate(
      input: RecommendationInput(
        recoveryDebt: debt,
        recoveryTrend: trend.trend,
        monthlyLoad: trend.monthlyLoad,
        burnoutRisk: burnout.risk,
        taskCompletionRate: taskController.weeklyCompletionRate,
        habitCompletionRate: habitRate,
        taskRates: taskRates,
        habitRates: habitRates,
      ),
      burnout: burnout,
    );

    final notifications = SmartNotificationScheduler.build(
      burnoutRisk: burnout.risk,
      recoveryTrend: trend.trend,
      recommendations: recommendations,
    );

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scheduled Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (notifications.isEmpty)
              const Text('No notifications scheduled.'),

            ...notifications.map((notification) {
              final time =
                  '${notification.scheduledTime.hour.toString().padLeft(2, '0')}:'
                  '${notification.scheduledTime.minute.toString().padLeft(2, '0')}';

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule, color: Colors.indigo),
                title: Text(notification.title),
                subtitle: Text(notification.body),
                trailing: Text(
                  time,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
