import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../tasks/presentation/controllers/task_controller.dart';
import '../../../tasks/domain/entities/task.dart';

class SmartListsScreen extends StatelessWidget {
  final String listType; // today, overdue, upcoming, completed, pinned

  const SmartListsScreen({super.key, required this.listType});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskController>();

    List<Task> tasks;
    String title;

    switch (listType) {
      case 'today':
        tasks = provider.todayTasks;
        title = "Today's Tasks";
        break;

      case 'overdue':
        tasks = provider.overdueTasks;
        title = 'Overdue Tasks';
        break;

      case 'upcoming':
        tasks = provider.upcomingTasks;
        title = 'Upcoming Tasks';
        break;

      case 'completed':
        tasks = provider.completedTasks;
        title = 'Completed Tasks';
        break;

      case 'pinned':
        tasks = provider.pinnedTasks;
        title = 'Pinned Tasks';
        break;

      default:
        tasks = provider.activeTasks;
        title = 'Tasks';
    }

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.blue.shade700),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks found.',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final task = tasks[index];
                final color = Color(task.categoryColor);

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/taskDetails',
                      arguments: task,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                task.dueDate == null
                                    ? 'No due date'
                                    : 'Due: ${task.dueDate!.toLocal().toString().split(' ').first}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            task.isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: task.isCompleted
                                ? Colors.green
                                : Colors.grey.shade600,
                          ),
                          onPressed: () {
                            context.read<TaskController>().toggleComplete(task);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
