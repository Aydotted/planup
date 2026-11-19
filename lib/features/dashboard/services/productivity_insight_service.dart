class ProductivityInsightService {
  static String? bestTaskShift(Map<String, double> taskRates) {
    if (taskRates.isEmpty) {
      return null;
    }

    final sorted = taskRates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }

  static String? worstTaskShift(Map<String, double> taskRates) {
    if (taskRates.isEmpty) {
      return null;
    }

    final sorted = taskRates.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return sorted.first.key;
  }

  static String? bestHabitShift(Map<String, double> habitRates) {
    if (habitRates.isEmpty) {
      return null;
    }

    final sorted = habitRates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }

  static String? worstHabitShift(Map<String, double> habitRates) {
    if (habitRates.isEmpty) {
      return null;
    }

    final sorted = habitRates.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return sorted.first.key;
  }

  static List<String> generateInsights({
    required Map<String, double> taskRates,
    required Map<String, double> habitRates,
  }) {
    final insights = <String>[];

    final bestTask = bestTaskShift(taskRates);

    final worstTask = worstTaskShift(taskRates);

    final bestHabit = bestHabitShift(habitRates);

    final worstHabit = worstHabitShift(habitRates);

    if (bestTask != null && worstTask != null && bestTask != worstTask) {
      insights.add(
        'Tasks perform best during $bestTask shifts and worst during $worstTask shifts.',
      );
    }

    if (bestHabit != null && worstHabit != null && bestHabit != worstHabit) {
      insights.add(
        'Habit consistency is strongest during $bestHabit shifts and lowest during $worstHabit shifts.',
      );
    }

    if (bestTask != null) {
      insights.add(
        'Consider scheduling high-priority work during $bestTask shifts.',
      );
    }

    if (bestHabit != null) {
      insights.add(
        'Use $bestHabit shifts for maintaining important habits and routines.',
      );
    }

    return insights;
  }
}
