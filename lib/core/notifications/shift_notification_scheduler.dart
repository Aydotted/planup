import '../../shared/services/notification_service.dart';
import '../../features/shifts/domain/entities/shift.dart';

class ShiftNotificationScheduler {
  Future<void> schedule(Shift shift) async {
    if (!(shift.notificationsEnabled ?? true)) {
      return;
    }

    if (shift.startTime == null) {
      return;
    }

    final reminderTime = shift.startTime!.subtract(
      Duration(minutes: shift.reminderMinutesBefore ?? 60),
    );

    if (!reminderTime.isAfter(DateTime.now())) {
      return;
    }

    try {
      await NotificationService.scheduleReminder(
        id: shift.id.hashCode,
        title: shift.shiftType,
        body:
            '${shift.shiftType} shift starts in '
            '${shift.reminderMinutesBefore ?? 60} minutes',
        dateTime: reminderTime,
      );
    } catch (_) {}
  }

  Future<void> cancel(Shift shift) async {
    await NotificationService.cancelReminder(shift.id.hashCode);
  }
}
