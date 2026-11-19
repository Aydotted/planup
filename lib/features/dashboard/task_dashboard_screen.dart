import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/tasks/presentation/controllers/task_controller.dart';
import '../../shared/widgets/productivity_chart.dart';
import '../habits/presentation/controllers/habit_controller.dart';

class TaskDashboardScreen extends StatelessWidget {
  const TaskDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskController>();
    final habits = context.watch<HabitProvider>();

    final total = tasks.tasks.length;
    final completed = tasks.completedTasks.length;
    final overdue = tasks.overdueTasks.length;
    final upcoming = tasks.upcomingTasks.length;

    final completionRate = total == 0
        ? 0
        : ((completed / total) * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Dashboard')),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatCard(
            title: 'Total Tasks',
            value: '$total',
            color: Colors.blue,
          ),
          _buildStatCard(
            title: 'Completed',
            value: '$completed',
            color: Colors.green,
          ),
          _buildStatCard(
            title: 'Completion Rate',
            value: '$completionRate%',
            color: Colors.purple,
          ),
          _buildStatCard(
            title: 'Overdue',
            value: '$overdue',
            color: Colors.red,
          ),
          _buildStatCard(
            title: 'Upcoming',
            value: '$upcoming',
            color: Colors.orange,
          ),

          const SizedBox(height: 24),

          const Text(
            'Weekly Productivity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ProductivityChart(tasks: tasks.tasks),

          const SizedBox(height: 24),

          const Text(
            'Habit Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ...habits.allHabits.map(
            (h) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(h.color),
                child: const Icon(Icons.category, color: Colors.white),
              ),
              title: Text(h.name),
              subtitle: Text('Streak: ${h.streak} days'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(Icons.analytics, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
