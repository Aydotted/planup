import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/task.dart';
import '../controllers/task_controller.dart';
import 'task_details_screen.dart';

class SortingScreen extends StatefulWidget {
  const SortingScreen({super.key});

  @override
  State<SortingScreen> createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> {
  String sortOption = 'priority';

  String priorityLabel(int p) {
    switch (p) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return 'Medium';
    }
  }

  List<Task> _sortTasks(List<Task> tasks) {
    switch (sortOption) {
      case 'priority':
        return [...tasks]..sort((a, b) => b.priority.compareTo(a.priority));

      case 'dueDate':
        return [...tasks]..sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) {
            return 0;
          }

          if (a.dueDate == null) {
            return 1;
          }

          if (b.dueDate == null) {
            return -1;
          }

          return a.dueDate!.compareTo(b.dueDate!);
        });

      case 'category':
        return [...tasks]..sort((a, b) {
          final aCat = a.categoryName ?? '';
          final bCat = b.categoryName ?? '';

          return aCat.compareTo(bCat);
        });

      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskController>();
    final tasks = provider.tasks;
    final sortedTasks = _sortTasks(tasks);

    return Scaffold(
      appBar: AppBar(title: const Text('Sort Tasks')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              initialValue: sortOption,
              decoration: const InputDecoration(
                labelText: 'Sort by',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'priority', child: Text('Priority')),
                DropdownMenuItem(value: 'dueDate', child: Text('Due Date')),
                DropdownMenuItem(value: 'category', child: Text('Category')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    sortOption = value;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: sortedTasks.isEmpty
                ? const Center(child: Text('No tasks available.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: sortedTasks.length,
                    itemBuilder: (_, index) {
                      final task = sortedTasks[index];
                      final color = Color(task.categoryColor);

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.category, color: color),
                          ),
                          title: Row(
                            children: [
                              Expanded(child: Text(task.title)),
                              if (task.isPinned)
                                const Icon(
                                  Icons.push_pin,
                                  size: 18,
                                  color: Colors.orange,
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Priority: ${priorityLabel(task.priority)}'),
                              if (task.dueDate != null)
                                Text(
                                  'Due: ${task.dueDate!.toLocal().toString().split(' ').first}',
                                ),
                              if (task.categoryName != null)
                                Text('Category: ${task.categoryName}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              task.isCompleted
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: task.isCompleted
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              context.read<TaskController>().toggleComplete(
                                task,
                              );
                            },
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailsScreen(task: task),
                              ),
                            );

                            await provider.updateTask(task);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
