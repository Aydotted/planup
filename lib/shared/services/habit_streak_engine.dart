class HabitStreakEngine {
  int calculateStreak(DateTime? lastCompleted) {
    if (lastCompleted == null) return 0;

    final now = DateTime.now();
    final diff = now.difference(lastCompleted).inDays;

    if (diff == 0) return 1; // completed today
    if (diff == 1) return 1; // streak continues
    return 0; // streak broken
  }

  int updateLongestStreak(int currentStreak, int longestStreak) {
    return currentStreak > longestStreak ? currentStreak : longestStreak;
  }
}
