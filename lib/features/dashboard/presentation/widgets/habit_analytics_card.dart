import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../habits/presentation/controllers/habit_controller.dart';
import '../../../habits/domain/entities/habit.dart';

class HabitAnalyticsCard extends StatelessWidget {
  const HabitAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitProvider>().allHabits;

    if (habits.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalHabits = habits.length;

    final completedToday = habits.where((habit) {
      final today = DateTime.now();

      return habit.completedDates.any(
        (date) =>
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day,
      );
    }).length;

    Habit bestHabit = habits.first;

    for (final habit in habits) {
      if (habit.longestStreak > bestHabit.longestStreak) {
        bestHabit = habit;
      }
    }

    final completionRate = totalHabits == 0
        ? 0
        : (completedToday / totalHabits);

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Habit Analytics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _statRow('Total Habits', totalHabits.toString()),

            _statRow('Completed Today', completedToday.toString()),

            _statRow('Completion Rate', '${(completionRate * 100).round()}%'),

            const Divider(height: 24),

            const Text(
              'Best Streak',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(bestHabit.name, style: const TextStyle(fontSize: 16)),

            Text(
              '${bestHabit.longestStreak} day streak',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
