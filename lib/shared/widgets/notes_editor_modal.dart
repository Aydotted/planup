import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/tasks/domain/entities/task.dart';
import '../../features/tasks/presentation/controllers/task_controller.dart';

class NotesEditorModal extends StatefulWidget {
  final Task task;

  const NotesEditorModal({super.key, required this.task});

  @override
  State<NotesEditorModal> createState() => _NotesEditorModalState();
}

class _NotesEditorModalState extends State<NotesEditorModal> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.task.notes);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskController>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Edit Notes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: controller,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: 'Write your notes here...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () async {
              widget.task.notes = controller.text.trim();
              await provider.updateTask(widget.task);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
