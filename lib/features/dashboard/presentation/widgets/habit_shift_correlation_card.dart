import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../habits/presentation/controllers/habit_controller.dart';

import '../../services/habit_shift_correlation_service.dart';

class HabitShiftCorrelationCard extends StatelessWidget {
  const HabitShiftCorrelationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitProvider>().allHabits;

    final shifts = context.watch<CalendarController>().shifts;

    final rates = HabitShiftCorrelationService.completionRates(
      habits: habits,
      shifts: shifts,
    );

    if (rates.isEmpty) {
      return const SizedBox.shrink();
    }

    final sorted = rates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final best = sorted.first;
    final worst = sorted.last;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Habit vs Shift Correlation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...sorted.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(entry.key)),
                    Text('${(entry.value * 100).round()}%'),
                  ],
                ),
              ),
            ),

            const Divider(),

            Text('Best Shift: ${best.key}'),

            const SizedBox(height: 6),

            Text('Worst Shift: ${worst.key}'),
          ],
        ),
      ),
    );
  }
}
