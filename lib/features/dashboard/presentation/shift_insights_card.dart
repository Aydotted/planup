import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../calendar/presentation/controllers/calendar_controller.dart';
import '../../tasks/presentation/controllers/task_controller.dart';

import '../services/advanced_insights_engine.dart';

class ShiftInsightsCard extends StatefulWidget {
  const ShiftInsightsCard({super.key});

  @override
  State<ShiftInsightsCard> createState() => _ShiftInsightsCardState();
}

class _ShiftInsightsCardState extends State<ShiftInsightsCard> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarController>();
    final taskController = context.watch<TaskController>();

    final monthlyShifts = calendar.shifts
        .where(
          (shift) =>
              shift.date.year == selectedMonth.year &&
              shift.date.month == selectedMonth.month,
        )
        .toList();

    final monthlyTasks = taskController.tasks.where((task) {
      if (task.dueDate == null) {
        return false;
      }

      return task.dueDate!.year == selectedMonth.year &&
          task.dueDate!.month == selectedMonth.month;
    }).toList();

    final insights = AdvancedInsightsEngine.generateInsights(
      shifts: monthlyShifts,
      tasks: monthlyTasks,
    );

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Insights',
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

            ...insights.map(
              (insight) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(child: Text(insight)),
                  ],
                ),
              ),
            ),
          ],
        ),
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
