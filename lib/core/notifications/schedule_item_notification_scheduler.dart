import 'package:flutter/foundation.dart';

import '../../features/schedule/domain/entities/schedule_item.dart';
import '../../shared/services/notification_service.dart';

class ScheduleItemNotificationScheduler {
  Future<void> schedule(ScheduleItem item) async {
    if (!item.notificationsEnabled) {
      return;
    }

    final reminderTime = item.dateTime.subtract(
      Duration(minutes: item.reminderMinutesBefore),
    );

    if (!reminderTime.isAfter(DateTime.now())) {
      return;
    }

    try {
      await NotificationService.scheduleReminder(
        id: item.notificationId ?? item.id.hashCode,
        title: item.title,
        body: _buildBody(item),
        dateTime: reminderTime,
      );
    } catch (e) {
      debugPrint('Notification scheduling failed: $e');
    }
  }

  Future<void> cancel(ScheduleItem item) async {
    await NotificationService.cancelReminder(
      item.notificationId ?? item.id.hashCode,
    );
  }

  String _buildBody(ScheduleItem item) {
    switch (item.type) {
      case ScheduleItemType.reminder:
        return 'Reminder due soon';

      case ScheduleItemType.subscription:
        return 'Subscription renewal approaching';

      case ScheduleItemType.personalEvent:
        return 'Event starts soon';

      case ScheduleItemType.task:
        return 'Task due soon';
    }
  }
}
