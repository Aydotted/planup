import 'recurrence_rule.dart';
import 'recurrence_type.dart';

class RecurrenceService {
  static DateTime getNextOccurrence(DateTime currentDate, RecurrenceRule rule) {
    switch (rule.recurrenceType) {
      case RecurrenceType.daily:
        return currentDate.add(Duration(days: rule.interval));

      case RecurrenceType.weekly:
        return currentDate.add(Duration(days: 7 * rule.interval));

      case RecurrenceType.monthly:
        return DateTime(
          currentDate.year,
          currentDate.month + rule.interval,
          currentDate.day,
        );

      case RecurrenceType.yearly:
        return DateTime(
          currentDate.year + rule.interval,
          currentDate.month,
          currentDate.day,
        );

      case RecurrenceType.custom:
        return currentDate.add(Duration(days: rule.interval));

      case RecurrenceType.none:
        return currentDate;
    }
  }
}
