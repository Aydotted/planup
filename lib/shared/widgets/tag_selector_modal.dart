import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/tasks/presentation/controllers/task_controller.dart';
import '../../features/tasks/domain/entities/task.dart';

class TagSelectorModal extends StatefulWidget {
  final Task task;

  const TagSelectorModal({super.key, required this.task});

  @override
  State<TagSelectorModal> createState() => _TagSelectorModalState();
}

class _TagSelectorModalState extends State<TagSelectorModal> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskController>(context);

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
            'Manage Tags',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Existing tags
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.task.tags.map((tag) {
              return Chip(
                label: Text(tag),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () async {
                  await taskProvider.removeTag(widget.task, tag);
                  setState(() {});
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Add new tag
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Add Tag',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) async {
              if (value.trim().isNotEmpty) {
                await taskProvider.addTag(widget.task, value.trim());
                _controller.clear();
                setState(() {});
              }
            },
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
