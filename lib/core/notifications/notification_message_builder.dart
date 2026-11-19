import 'notification_message.dart';

class InsightNotificationService {
  static List<NotificationMessage> buildMessages({
    required String burnoutRisk,
    required String recoveryTrend,
    required String monthlyLoad,
    required List<String> recommendations,
  }) {
    final messages = <NotificationMessage>[];

    if (burnoutRisk == 'High') {
      messages.add(
        const NotificationMessage(
          title: 'Burnout Risk',
          body: 'Your current burnout risk is high. Prioritise recovery.',
        ),
      );
    }

    if (recoveryTrend == 'Declining') {
      messages.add(
        const NotificationMessage(
          title: 'Recovery Alert',
          body:
              'Recovery trend is declining. Consider scheduling recovery time.',
        ),
      );
    }

    if (monthlyLoad == 'Chronic') {
      messages.add(
        const NotificationMessage(
          title: 'Sustained Workload',
          body: 'Workload has remained elevated for an extended period.',
        ),
      );
    }

    for (final recommendation in recommendations.take(2)) {
      messages.add(
        NotificationMessage(title: 'PlanUp Insight', body: recommendation),
      );
    }

    return messages;
  }
}
