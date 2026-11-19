import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/tasks/domain/entities/subtask.dart';
import '../../features/tasks/domain/entities/task.dart';
import '../../features/tasks/presentation/controllers/task_controller.dart';

class SubtaskChecklist extends StatefulWidget {
  final Task task;

  const SubtaskChecklist({super.key, required this.task});

  @override
  State<SubtaskChecklist> createState() => _SubtaskChecklistState();
}

class _SubtaskChecklistState extends State<SubtaskChecklist> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addSubtask() async {
    final title = _controller.text.trim();

    if (title.isEmpty) return;

    final controller = context.read<TaskController>();

    final updatedSubtasks = [
      ...widget.task.subtasks,
      Subtask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
      ),
    ];

    final updatedTask = widget.task.copyWith(
      subtasks: updatedSubtasks,
      updatedAt: DateTime.now(),
    );

    updatedTask.calculateProgress();

    await controller.updateTask(updatedTask);

    _controller.clear();
  }

  Future<void> _deleteSubtask(Subtask subtask) async {
    final controller = context.read<TaskController>();

    final updatedSubtasks = widget.task.subtasks
        .where((s) => s.id != subtask.id)
        .toList();

    final updatedTask = widget.task.copyWith(
      subtasks: updatedSubtasks,
      updatedAt: DateTime.now(),
    );

    updatedTask.calculateProgress();

    await controller.updateTask(updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TaskController>();

    final subtasks = widget.task.subtasks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subtasks',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        ...subtasks.map(
          (subtask) => ListTile(
            contentPadding: EdgeInsets.zero,

            leading: Checkbox(
              value: subtask.isCompleted,
              onChanged: (_) async {
                await controller.toggleSubtask(widget.task, subtask);

                if (mounted) {
                  setState(() {});
                }
              },
            ),

            title: Text(
              subtask.title,
              style: TextStyle(
                decoration: subtask.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
                color: subtask.isCompleted ? Colors.grey : null,
              ),
            ),

            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                _deleteSubtask(subtask);
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Add a subtask',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _addSubtask(),
        ),
      ],
    );
  }
}
