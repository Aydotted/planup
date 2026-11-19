import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/task.dart';
import '../../presentation/controllers/task_controller.dart';

class TaskEditorScreen extends StatefulWidget {
  final Task? existingTask;

  const TaskEditorScreen({Key? key, this.existingTask}) : super(key: key);

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  late TextEditingController titleController;
  late TextEditingController notesController;

  DateTime? dueDate;
  double progress = 0.0;
  int color = Colors.blue.toARGB32();
  List<String> tags = [];

  @override
  void initState() {
    super.initState();

    final t = widget.existingTask;

    titleController = TextEditingController(text: t?.title ?? '');
    notesController = TextEditingController(text: t?.notes ?? '');
    dueDate = t?.dueDate;
    progress = t?.progress ?? 0.0;
    color = t?.color ?? Colors.blue.toARGB32();
    tags = List<String>.from(t?.tags ?? []);
  }

  Future<void> pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (selected != null) {
      setState(() => dueDate = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTask != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'New Task'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              title: Text(
                dueDate == null
                    ? 'No due date'
                    : 'Due: ${dueDate!.toLocal().toString().split(" ").first}',
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: pickDate,
            ),

            const SizedBox(height: 20),

            const Text(
              'Progress',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Slider(
              value: progress,
              onChanged: (v) => setState(() => progress = v),
              activeColor: Color(color),
            ),
            Text('${(progress * 100).round()}% complete'),

            const SizedBox(height: 20),

            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Task Colour',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Wrap(
              spacing: 12,
              children:
                  [
                    Colors.blue,
                    Colors.orange,
                    Colors.green,
                    Colors.purple,
                    Colors.red,
                    Colors.teal,
                  ].map((c) {
                    return GestureDetector(
                      onTap: () => setState(() => color = c.value),
                      child: CircleAvatar(
                        backgroundColor: c,
                        radius: 18,
                        child: color == c.toARGB32()
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final task = Task(
                    id:
                        widget.existingTask?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text.trim(),
                    description: null,
                    createdAt: widget.existingTask?.createdAt ?? DateTime.now(),
                    updatedAt: DateTime.now(),
                    dueDate: dueDate,
                    isCompleted: widget.existingTask?.isCompleted ?? false,
                    isArchived: widget.existingTask?.isArchived ?? false,
                    isPinned: widget.existingTask?.isPinned ?? false,
                    priority: widget.existingTask?.priority ?? 1,
                    color: color,
                    tags: tags,
                    subtasks: widget.existingTask?.subtasks ?? [],
                    categoryId: widget.existingTask?.categoryId,
                    categoryColor:
                        widget.existingTask?.categoryColor ?? 0xFF2196F3,
                    categoryIconCodePoint:
                        widget.existingTask?.categoryIconCodePoint ?? 0xE87C,
                    recurrence: widget.existingTask?.recurrence ?? 'none',
                    reminderMinutesBefore:
                        widget.existingTask?.reminderMinutesBefore ?? 0,
                    attachments: widget.existingTask?.attachments ?? [],
                    notes: notesController.text.trim(),
                    progress: progress,
                    categoryName: widget.existingTask?.categoryName,
                    deleted: widget.existingTask?.deleted ?? false,
                    startTime: widget.existingTask?.startTime,
                    endTime: widget.existingTask?.endTime,
                    notificationId: widget.existingTask?.notificationId,
                  );

                  Provider.of<TaskController>(
                    context,
                    listen: false,
                  ).addTask(task);

                  Navigator.pop(context);
                },
                child: Text(
                  isEditing ? 'Save Changes' : 'Create Task',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
