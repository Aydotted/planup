import '../../habits/domain/entities/habit.dart';
import '../../shifts/domain/entities/shift.dart';

class HabitShiftCorrelationService {
  static Map<String, double> completionRates({
    required List<Habit> habits,
    required List<Shift> shifts,
  }) {
    final Map<String, int> opportunities = {};
    final Map<String, int> completions = {};

    for (final shift in shifts) {
      final date = DateTime(shift.date.year, shift.date.month, shift.date.day);

      for (final habit in habits) {
        final completed = habit.completedDates.any(
          (d) =>
              d.year == date.year && d.month == date.month && d.day == date.day,
        );

        opportunities[shift.shiftType] =
            (opportunities[shift.shiftType] ?? 0) + 1;

        if (completed) {
          completions[shift.shiftType] =
              (completions[shift.shiftType] ?? 0) + 1;
        }
      }
    }

    final result = <String, double>{};

    opportunities.forEach((shiftType, total) {
      result[shiftType] = total == 0
          ? 0
          : (completions[shiftType] ?? 0) / total;
    });

    return result;
  }
}
