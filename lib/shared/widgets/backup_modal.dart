import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:planup_fixed_new/features/tasks/domain/entities/task.dart';
import 'package:planup_fixed_new/features/tasks/presentation/controllers/task_controller.dart';

class BackupModal extends StatefulWidget {
  const BackupModal({super.key});

  @override
  State<BackupModal> createState() => _BackupModalState();
}

class _BackupModalState extends State<BackupModal> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _exportTasks(List<Task> tasks) {
    final data = tasks
        .map(
          (t) => {
            'id': t.id,
            'title': t.title,
            'description': t.description,
            'createdAt': t.createdAt.toIso8601String(),
            'updatedAt': t.updatedAt.toIso8601String(),
            'dueDate': t.dueDate?.toIso8601String(),
            'isCompleted': t.isCompleted,
          },
        )
        .toList();

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Backup & Restore',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text('Export Tasks'),
            onPressed: () {
              _controller.text = _exportTasks(provider.tasks);
            },
          ),

          const SizedBox(height: 16),

          TextField(
            controller: _controller,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Backup JSON',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            icon: const Icon(Icons.upload),
            label: const Text('Import Tasks'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task import will be implemented later.'),
                ),
              );

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
