import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/focus_recommendation_engine.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/controllers/task_controller.dart';
import '../../../shifts/domain/entities/shift.dart';

class TodaysFocusCard extends StatelessWidget {
  const TodaysFocusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();
    final calendarController = context.watch<CalendarController>();

    final today = DateTime.now();

    final todayTasks = taskController.tasks.where((task) {
      if (task.dueDate == null) return false;

      return task.dueDate!.year == today.year &&
          task.dueDate!.month == today.month &&
          task.dueDate!.day == today.day;
    }).toList();

    final overdueTasks = taskController.tasks.where((task) {
      if (task.dueDate == null) return false;

      return !task.isCompleted &&
          task.dueDate!.isBefore(DateTime(today.year, today.month, today.day));
    }).toList();

    final todayShifts = calendarController.shiftsForDate(today);

    Shift? shift;

    if (todayShifts.isNotEmpty) {
      shift = todayShifts.first;
    }

    final recommendation = FocusRecommendationEngine.generateRecommendation(
      shiftType: shift?.shiftType,
      overdueTasks: overdueTasks.length,
      dueToday: todayTasks.length,
      completionRate: taskController.weeklyCompletionRate,
    );

    final workload = FocusRecommendationEngine.workloadLevel(
      overdueTasks: overdueTasks.length,
      dueToday: todayTasks.length,
    );

    final priority = FocusRecommendationEngine.priorityLevel(
      overdueTasks: overdueTasks.length,
      dueToday: todayTasks.length,
    );

    final performance = FocusRecommendationEngine.productivityStatus(
      taskController.weeklyCompletionRate,
    );

    Task? focusTask;

    if (overdueTasks.isNotEmpty) {
      focusTask = overdueTasks.first;
    } else if (todayTasks.isNotEmpty) {
      focusTask = todayTasks.first;
    }

    Color priorityColor = Colors.green;

    switch (priority.toLowerCase()) {
      case 'high':
        priorityColor = Colors.red;
        break;
      case 'medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Focus",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            if (shift != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.work_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Current Shift: ${shift.shiftType}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            if (shift != null) const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.task_alt, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      focusTask == null
                          ? 'No priority task for today'
                          : focusTask.title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _metric(
                    'Due Today',
                    '${todayTasks.length}',
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _metric(
                    'Overdue',
                    '${overdueTasks.length}',
                    Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            LinearProgressIndicator(
              value: taskController.weeklyCompletionRate.clamp(0.0, 1.0),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 8),

            Text(
              'Weekly Completion: '
              '${(taskController.weeklyCompletionRate * 100).round()}%',
            ),

            const Divider(height: 28),

            Row(
              children: [
                Expanded(
                  child: _statusTile('Priority', priority, priorityColor),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _statusTile('Workload', workload, Colors.indigo),
                ),
              ],
            ),

            const SizedBox(height: 8),

            _statusTile('Performance', performance, Colors.teal),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommendation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(recommendation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _statusTile(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
