import 'scheduled_notification.dart';

class SmartNotificationScheduler {
  static List<ScheduledNotification> build({
    required String burnoutRisk,
    required String recoveryTrend,
    required List<String> recommendations,
  }) {
    final notifications = <ScheduledNotification>[];

    final now = DateTime.now();

    if (burnoutRisk == 'High') {
      notifications.add(
        ScheduledNotification(
          title: 'Burnout Alert',
          body: 'Burnout risk is elevated. Consider reducing workload.',
          scheduledTime: DateTime(now.year, now.month, now.day, 18, 0),
        ),
      );
    }

    if (recoveryTrend == 'Declining') {
      notifications.add(
        ScheduledNotification(
          title: 'Recovery Reminder',
          body: 'Recovery trend is declining. Schedule recovery time.',
          scheduledTime: DateTime(now.year, now.month, now.day, 19, 0),
        ),
      );
    }

    if (recommendations.isNotEmpty) {
      notifications.add(
        ScheduledNotification(
          title: 'PlanUp Insight',
          body: recommendations.first,
          scheduledTime: DateTime(now.year, now.month, now.day, 8, 0),
        ),
      );
    }

    return notifications;
  }
}
