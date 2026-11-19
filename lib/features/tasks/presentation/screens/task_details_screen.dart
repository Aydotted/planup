import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/controllers/task_controller.dart';
import '../../domain/entities/task.dart';
import 'task_editor_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskEditorScreen(existingTask: task),
                ),
              );

              await provider.updateTask(task);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(task.color).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.task_alt, color: Color(task.color)),
                ),
                const SizedBox(width: 12),
                Text(
                  'Colour',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(
                task.dueDate == null
                    ? 'No due date'
                    : 'Due: ${task.dueDate!.toLocal().toString().split(' ').first}',
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Progress',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: task.progress,
              backgroundColor: Colors.grey.shade200,
              color: Color(task.color),
              minHeight: 6,
            ),

            const SizedBox(height: 6),

            Text('${(task.progress * 100).round()}% complete'),

            const SizedBox(height: 20),

            if (task.tags.isNotEmpty) ...[
              const Text(
                'Tags',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: task.tags.map((t) => Chip(label: Text(t))).toList(),
              ),

              const SizedBox(height: 20),
            ],

            const Text(
              'Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Text(
              (task.notes ?? '').isEmpty ? 'No notes added.' : task.notes!,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await provider.deleteTask(task.id);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Delete Task',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
