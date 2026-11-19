import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tasks/presentation/controllers/task_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();

    final totalTasks = taskController.tasks.length;
    final completedTasks = taskController.completedTasks.length;
    final activeTasks = taskController.activeTasks.length;
    final todayTasks = taskController.todayTasks.length;
    final overdueTasks = taskController.overdueTasks.length;

    final completionRate = totalTasks == 0
        ? 0
        : ((completedTasks / totalTasks) * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              'PlanUp User',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Total Tasks'),
              trailing: Text('$totalTasks'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Completed Tasks'),
              trailing: Text('$completedTasks'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.pending_actions),
              title: const Text('Active Tasks'),
              trailing: Text('$activeTasks'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Today Tasks'),
              trailing: Text('$todayTasks'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.warning_amber),
              title: const Text('Overdue Tasks'),
              trailing: Text('$overdueTasks'),
            ),
          ),

          const SizedBox(height: 24),

          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Completion Rate',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  LinearProgressIndicator(
                    value: completionRate / 100,
                    minHeight: 10,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '$completionRate%',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Card(
            child: ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Weekly Completion'),
              trailing: Text(
                '${(taskController.weeklyCompletionRate * 100).round()}%',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
