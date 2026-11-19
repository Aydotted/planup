import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/task.dart';
import '../../presentation/controllers/task_controller.dart';

import '../../../../shared/widgets/pinned_tasks_section.dart';
import '../../../../shared/widgets/tag_chips.dart';
import '../../../../shared/widgets/tag_selector_modal.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskController>();
    final activeTasks = provider.activeTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.pushNamed(context, '/calendar'),
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => Navigator.pushNamed(context, '/smartLists'),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => Navigator.pushNamed(context, '/sorting'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/addTask'),
      ),
      body: activeTasks.isEmpty
          ? Center(
              child: Text(
                'No tasks yet. Tap + to create one.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const PinnedTasksSection(),
                const SizedBox(height: 12),
                const Text(
                  'Your Tasks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...activeTasks.map((task) => _TaskCard(task: task)),
              ],
            ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final color = Color(task.categoryColor);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.category, color: color),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                task.dueDate == null
                    ? 'No due date'
                    : 'Due: ${task.dueDate!.toLocal().toString().split(" ").first}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      task.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      color: task.isPinned ? Colors.orange : Colors.grey,
                    ),
                    onPressed: () {
                      final controller = Provider.of<TaskController>(
                        context,
                        listen: false,
                      );
                      controller.updateTask(
                        task.copyWith(isPinned: !task.isPinned),
                      );
                    },
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
                      Provider.of<TaskController>(
                        context,
                        listen: false,
                      ).toggleComplete(task);
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/taskDetails', arguments: task);
              },
            ),
            const SizedBox(height: 8),
            if (task.tags.isNotEmpty) TagChips(tags: task.tags),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: task.progress,
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 6,
            ),
            const SizedBox(height: 6),
            Text(
              '${(task.progress * 100).round()}% complete',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.label),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => TagSelectorModal(task: task),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
