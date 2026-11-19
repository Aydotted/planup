import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/habit.dart';

class HabitProvider extends ChangeNotifier {
  final Box<Habit> _habitBox = Hive.box<Habit>('habits');

  List<Habit> get allHabits => _habitBox.values.toList();

  Future<void> addHabit(Habit habit) async {
    await _habitBox.put(habit.id, habit);
    notifyListeners();
  }

  Future<void> deleteHabit(Habit habit) async {
    await _habitBox.delete(habit.id);
    notifyListeners();
  }

  Future<void> toggleHabit(Habit habit) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Prevent double completion
    if (habit.completedDates.any(
      (d) =>
          d.year == today.year && d.month == today.month && d.day == today.day,
    )) {
      return;
    }

    habit.completedDates = [...habit.completedDates, todayDate];

    // Streak logic
    if (habit.lastCompletedDate == null) {
      habit.streak = 1;
    } else {
      final last = habit.lastCompletedDate!;
      final yesterday = todayDate.subtract(const Duration(days: 1));

      if (last.year == yesterday.year &&
          last.month == yesterday.month &&
          last.day == yesterday.day) {
        habit.streak += 1;
      } else {
        habit.streak = 1;
      }
    }

    // Update longest streak
    if (habit.streak > habit.longestStreak) {
      habit.longestStreak = habit.streak;
    }

    habit.lastCompletedDate = todayDate;

    await habit.save();
    notifyListeners();
  }
}
