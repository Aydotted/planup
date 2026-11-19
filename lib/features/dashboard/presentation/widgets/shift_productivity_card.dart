import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../tasks/presentation/controllers/task_controller.dart';

class ShiftProductivityCard extends StatefulWidget {
  const ShiftProductivityCard({super.key});

  @override
  State<ShiftProductivityCard> createState() => _ShiftProductivityCardState();
}

class _ShiftProductivityCardState extends State<ShiftProductivityCard> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarController>();

    final taskController = context.watch<TaskController>();

    final shifts = calendar.shifts
        .where(
          (shift) =>
              shift.date.year == selectedMonth.year &&
              shift.date.month == selectedMonth.month,
        )
        .toList();

    final tasks = taskController.tasks
        .where(
          (task) =>
              task.dueDate != null &&
              task.dueDate!.year == selectedMonth.year &&
              task.dueDate!.month == selectedMonth.month,
        )
        .toList();

    final Map<String, int> totalTasks = {};
    final Map<String, int> completedTasks = {};

    for (final shift in shifts) {
      final shiftDate = DateTime(
        shift.date.year,
        shift.date.month,
        shift.date.day,
      );

      final tasksForDay = tasks.where(
        (task) =>
            task.dueDate != null &&
            task.dueDate!.year == shiftDate.year &&
            task.dueDate!.month == shiftDate.month &&
            task.dueDate!.day == shiftDate.day,
      );

      totalTasks.update(
        shift.shiftType,
        (value) => value + tasksForDay.length,
        ifAbsent: () => tasksForDay.length,
      );

      completedTasks.update(
        shift.shiftType,
        (value) => value + tasksForDay.where((t) => t.isCompleted).length,
        ifAbsent: () => tasksForDay.where((t) => t.isCompleted).length,
      );
    }

    String bestShift = 'No Data';
    String worstShift = 'No Data';

    double bestRate = 0;
    double worstRate = 100;

    if (totalTasks.isNotEmpty) {
      for (final entry in totalTasks.entries) {
        final total = entry.value;

        if (total == 0) continue;

        final completed = completedTasks[entry.key] ?? 0;

        final rate = (completed / total) * 100;

        if (rate > bestRate) {
          bestRate = rate;
          bestShift = entry.key;
        }

        if (rate < worstRate) {
          worstRate = rate;
          worstShift = entry.key;
        }
      }
    }

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Productivity by Shift',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month - 1,
                      );
                    });
                  },
                ),

                Expanded(
                  child: Center(
                    child: Text(
                      '${_monthName(selectedMonth.month)} '
                      '${selectedMonth.year}',
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),

            const Divider(),

            if (totalTasks.isNotEmpty) ...[
              _summaryRow(
                'Most Productive',
                bestShift,
                '${bestRate.toStringAsFixed(0)}%',
                Colors.green,
              ),

              const SizedBox(height: 8),

              _summaryRow(
                'Least Productive',
                worstShift,
                '${worstRate.toStringAsFixed(0)}%',
                Colors.red,
              ),

              const Divider(),
            ],

            if (totalTasks.isEmpty)
              const Text('No productivity data available.')
            else
              ...totalTasks.entries.map((entry) {
                final total = entry.value;

                final completed = completedTasks[entry.key] ?? 0;

                final rate = total == 0 ? 0 : (completed / total) * 100;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(entry.key)),
                          Text(
                            '${rate.toStringAsFixed(0)}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      LinearProgressIndicator(
                        value: total == 0 ? 0 : completed / total,
                      ),

                      const SizedBox(height: 2),

                      Text(
                        '$completed of $total tasks completed',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String title, String shift, String rate, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(shift),
              ],
            ),
          ),
          Text(
            rate,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month];
  }
}
