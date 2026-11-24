import 'recurrence_type.dart';
import 'recurrence_end_type.dart';

class RecurrenceRule {
  final RecurrenceType recurrenceType;

  final int interval;

  final RecurrenceEndType endType;

  final DateTime? endDate;

  final int? maxOccurrences;

  const RecurrenceRule({
    required this.recurrenceType,
    this.interval = 1,
    this.endType = RecurrenceEndType.never,
    this.endDate,
    this.maxOccurrences,
  });
}
