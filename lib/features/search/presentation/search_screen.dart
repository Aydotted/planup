import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:planup_fixed_new/features/tasks/presentation/controllers/task_controller.dart';

import '../../tasks/presentation/screens/task_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskController>();
    final tasks = provider.tasks;

    final filtered = tasks.where((task) {
      final q = query.toLowerCase();

      return task.title.toLowerCase().contains(q) ||
          (task.description?.toLowerCase().contains(q) ?? false) ||
          (task.notes?.toLowerCase().contains(q) ?? false) ||
          task.tags.any((tag) => tag.toLowerCase().contains(q)) ||
          priorityLabel(task.priority).toLowerCase().contains(q) ||
          (task.categoryName?.toLowerCase().contains(q) ?? false);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Tasks'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by title, tags, notes, category...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  query = value.trim();
                });
              },
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No matching tasks.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (_, index) {
                      final task = filtered[index];
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
                            children: [
                              if (task.dueDate != null)
                                Text(
                                  'Due: ${task.dueDate!.toLocal().toString().split(' ').first}',
                                ),
                              if (task.description != null &&
                                  task.description!.isNotEmpty)
                                Text(task.description!),
                              if (task.notes != null && task.notes!.isNotEmpty)
                                Text(
                                  'Notes: ${task.notes}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              Text('Priority: ${priorityLabel(task.priority)}'),
                              if (task.tags.isNotEmpty)
                                Text(
                                  'Tags: ${task.tags.join(", ")}',
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                  ),
                                ),
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

                            provider.updateTask(task);
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
