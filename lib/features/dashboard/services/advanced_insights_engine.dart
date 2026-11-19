import '../../calendar/presentation/controllers/calendar_controller.dart';
import '../../shifts/domain/entities/shift.dart';
import '../../tasks/domain/entities/task.dart';

class AdvancedInsightsEngine {
  static List<String> generateInsights({
    required List<Shift> shifts,
    required List<Task> tasks,
  }) {
    final insights = <String>[];

    if (shifts.isEmpty) {
      insights.add('No shift data available yet.');
      return insights;
    }

    final shiftCounts = <String, int>{};

    for (final shift in shifts) {
      shiftCounts.update(
        shift.shiftType,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    if (shiftCounts.isNotEmpty) {
      final mostCommonShift = shiftCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;

      insights.add('Your most common shift this month is $mostCommonShift.');
    }

    final nightShifts = shifts.where((s) => s.shiftType == 'Night').length;

    if (nightShifts >= 6) {
      insights.add(
        'You have worked $nightShifts night shifts this month. Consider prioritising recovery time.',
      );
    }

    final offDays = shifts.where((s) => s.shiftType == 'Off').length;

    if (offDays <= 2) {
      insights.add(
        'You have had limited off days this month. Monitor workload carefully.',
      );
    }

    final overdueTasks = tasks.where((task) => !task.isCompleted).length;

    if (overdueTasks >= 5) {
      insights.add(
        'You currently have $overdueTasks unfinished tasks requiring attention.',
      );
    }

    int longestWorkStreak = 0;
    int currentStreak = 0;

    final sorted = [...shifts]..sort((a, b) => a.date.compareTo(b.date));

    for (final shift in sorted) {
      if (shift.shiftType == 'Off') {
        currentStreak = 0;
        continue;
      }

      currentStreak++;

      if (currentStreak > longestWorkStreak) {
        longestWorkStreak = currentStreak;
      }
    }

    if (longestWorkStreak >= 5) {
      insights.add(
        'Your longest work streak this month was $longestWorkStreak days.',
      );
    }

    if (insights.isEmpty) {
      insights.add(
        'Your shift pattern and workload appear balanced this month.',
      );
    }

    return insights;
  }
}
