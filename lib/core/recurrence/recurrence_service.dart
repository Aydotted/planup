import 'recurrence_rule.dart';
import 'recurrence_type.dart';
import 'recurrence_end_type.dart';

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

  static List<DateTime> generateOccurrences(
    DateTime startDate,
    RecurrenceRule rule,
    int count,
  ) {
    final List<DateTime> occurrences = [];

    DateTime current = startDate;

    for (int i = 0; i < count; i++) {
      occurrences.add(current);

      current = getNextOccurrence(current, rule);
    }

    return occurrences;
  }

  static bool hasEnded(
    DateTime occurrenceDate,
    RecurrenceRule rule,
    int occurrenceCount,
  ) {
    switch (rule.endType) {
      case RecurrenceEndType.never:
        return false;

      case RecurrenceEndType.endDate:
        return rule.endDate != null && occurrenceDate.isAfter(rule.endDate!);

      case RecurrenceEndType.occurrenceCount:
        return rule.maxOccurrences != null &&
            occurrenceCount >= rule.maxOccurrences!;
    }
  }

  static List<DateTime> generateUntilDate(
    DateTime startDate,
    RecurrenceRule rule,
    DateTime targetDate,
  ) {
    final List<DateTime> occurrences = [];

    DateTime current = startDate;

    int occurrenceCount = 0;

    while (current.isBefore(targetDate) ||
        current.isAtSameMomentAs(targetDate)) {
      if (hasEnded(current, rule, occurrenceCount)) {
        break;
      }

      occurrences.add(current);

      current = getNextOccurrence(current, rule);

      occurrenceCount++;
    }

    return occurrences;
  }

  static bool shouldGenerateFutureOccurrences(RecurrenceRule rule) {
    return rule.recurrenceType != RecurrenceType.none;
  }
}
