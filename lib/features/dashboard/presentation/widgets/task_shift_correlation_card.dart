import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../tasks/presentation/controllers/task_controller.dart';

import '../../services/task_shift_correlation_service.dart';

class TaskShiftCorrelationCard extends StatelessWidget {
  const TaskShiftCorrelationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskController>().tasks;

    final shifts = context.watch<CalendarController>().shifts;

    final stats = TaskShiftCorrelationService.shiftStatistics(
      tasks: tasks,
      shifts: shifts,
    );

    if (stats.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(12),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Task vs Shift Correlation: Not enough data yet.'),
        ),
      );
    }

    final sorted = [...stats]
      ..sort((a, b) => b.completionRate.compareTo(a.completionRate));

    final best = sorted.first;
    final worst = sorted.last;
    final rates = TaskShiftCorrelationService.completionRates(
      tasks: tasks,
      shifts: shifts,
    );
    final insight = TaskShiftCorrelationService.productivityInsight(rates);

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task vs Shift Correlation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...sorted.map(
              (stat) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text(stat.shiftType)),
                    Expanded(child: Text('${stat.totalTasks}')),

                    Text('${(stat.completionRate * 100).round()}%'),
                  ],
                ),
              ),
            ),

            const Divider(),

            Text('Most Productive: ${best.shiftType}'),

            const SizedBox(height: 6),

            Text('Least Productive: ${worst.shiftType}'),

            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(insight),
            ),
          ],
        ),
      ),
    );
  }
}
