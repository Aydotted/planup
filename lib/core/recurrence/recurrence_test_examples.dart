import 'recurrence_end_type.dart';
import 'recurrence_rule.dart';
import 'recurrence_service.dart';
import 'recurrence_type.dart';

void runRecurrenceExamples() {
  final rule = RecurrenceRule(
    recurrenceType: RecurrenceType.monthly,
    interval: 1,
    endType: RecurrenceEndType.never,
  );

  final results = RecurrenceService.generateOccurrences(
    DateTime(2026, 1, 1),
    rule,
    12,
  );

  for (final occurrence in results) {
    print(occurrence);
  }
}
