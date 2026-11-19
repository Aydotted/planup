import 'package:flutter/material.dart';
import 'package:planup_fixed_new/features/category/domain/entities/category.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/controllers/task_controller.dart';
import '../../../category/presentation/category_picker_screen.dart';
import '../../../../core/utils/priority_color.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late Task task;

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  DateTime? dueDate;

  String? categoryId;
  String categoryName = 'General';
  int categoryColor = Colors.blue.value;

  String priority = 'medium';
  bool reminderEnabled = true;
  int reminderMinutesBefore = 10;

  String recurrence = 'none';

  List<String> attachments = [];

  @override
  void initState() {
    super.initState();

    task = widget.task;

    titleController = TextEditingController(text: task.title);
    descriptionController = TextEditingController(text: task.description);

    dueDate = task.dueDate;

    categoryId = task.categoryId;
    categoryColor = task.categoryColor;
    categoryName = task.categoryName ?? 'General';

    priority = _priorityFromInt(task.priority);

    reminderEnabled = task.reminderMinutesBefore > 0;
    reminderMinutesBefore = reminderEnabled ? task.reminderMinutesBefore : 10;

    recurrence = task.recurrence;

    attachments = List<String>.from(task.attachments);
  }

  String _priorityFromInt(int p) {
    switch (p) {
      case 0:
        return 'low';
      case 1:
        return 'medium';
      case 2:
        return 'high';
      default:
        return 'medium';
    }
  }

  int _priorityToInt(String p) {
    switch (p) {
      case 'low':
        return 0;
      case 'medium':
        return 1;
      case 'high':
        return 2;
      default:
        return 1;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        attachments.add(file.path);
      });
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.path != null) {
        setState(() {
          attachments.add(file.path!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),

            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),

            const SizedBox(height: 12),
            ListTile(
              title: Text(
                dueDate == null
                    ? 'Select Due Date'
                    : 'Due: ${dueDate.toString().substring(0, 16)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: dueDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      dueDate = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                }
              },
            ),

            const SizedBox(height: 12),
            ListTile(
              title: Text('Category: $categoryName'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CategoryPickerScreen(),
                  ),
                );

                if (result != null && result is Category) {
                  setState(() {
                    categoryId = result.id;
                    categoryName = result.name;
                    categoryColor = result.color;
                  });
                }
              },
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: priority,
              items: ['low', 'medium', 'high']
                  .map(
                    (p) => DropdownMenuItem<String>(
                      value: p,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: PriorityColor.getColor(
                                p == 'low'
                                    ? 0
                                    : p == 'medium'
                                    ? 1
                                    : 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(p),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => priority = v!),
              decoration: const InputDecoration(labelText: 'Priority'),
            ),

            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Enable Reminder'),
              value: reminderEnabled,
              onChanged: (v) => setState(() => reminderEnabled = v),
            ),

            if (reminderEnabled)
              DropdownButtonFormField<int>(
                initialValue: reminderMinutesBefore,
                items: [5, 10, 15, 30, 60]
                    .map(
                      (m) => DropdownMenuItem(
                        value: m,
                        child: Text('$m minutes before'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => reminderMinutesBefore = v!),
                decoration: const InputDecoration(labelText: 'Reminder Time'),
              ),

            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: recurrence,
              decoration: const InputDecoration(labelText: 'Recurrence'),
              items: ['none', 'daily', 'weekly', 'monthly']
                  .map(
                    (r) => DropdownMenuItem(
                      value: r,
                      child: Text(r.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  recurrence = value!;
                });
              },
            ),

            const SizedBox(height: 20),
            const Text(
              'Attachments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Add Image'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Add File'),
                ),
              ],
            ),

            const SizedBox(height: 12),
            ...attachments.map(
              (path) => ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(path.split('/').last),
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty || dueDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title and due date required'),
                    ),
                  );
                  return;
                }

                final updated = task.copyWith(
                  title: titleController.text,
                  description: descriptionController.text,
                  dueDate: dueDate!,
                  priority: _priorityToInt(priority),
                  categoryId: categoryId,
                  categoryColor: categoryColor,
                  categoryName: categoryName,
                  recurrence: recurrence,
                  reminderMinutesBefore: reminderEnabled
                      ? reminderMinutesBefore
                      : 0,
                  attachments: attachments,
                );

                provider.updateTask(updated);

                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
