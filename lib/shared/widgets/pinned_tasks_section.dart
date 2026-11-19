import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/tasks/domain/entities/task.dart';
import '../../features/tasks/presentation/controllers/task_controller.dart';

class PinnedTasksSection extends StatelessWidget {
  const PinnedTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskController>();

    final pinnedTasks = taskProvider.tasks
        .where((t) => t.isPinned && !t.deleted && !t.isArchived)
        .toList();

    if (pinnedTasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pinned',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...pinnedTasks.map((task) => _PinnedTaskCard(task: task)),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _PinnedTaskCard extends StatelessWidget {
  final Task task;

  const _PinnedTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskController>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.push_pin, color: Colors.amber),
        ),
        title: Text(task.title),
        subtitle: Text(
          task.dueDate == null
              ? 'No due date'
              : 'Due: ${task.dueDate!.toLocal().toString().split(' ').first}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Unpin task',
          onPressed: () async {
            await taskProvider.togglePinned(task);
          },
        ),
        onTap: () {
          Navigator.pushNamed(context, '/taskDetails', arguments: task);
        },
      ),
    );
  }
}
