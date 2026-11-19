import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/controllers/task_controller.dart';
import '../../../category/domain/entities/category.dart';
import '../../../category/presentation/category_picker_screen.dart';

class AddTaskScreen extends StatefulWidget {
  final DateTime? prefilledDate;

  const AddTaskScreen({super.key, this.prefilledDate});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _dueDate;

  String? _categoryId;
  String _categoryName = 'General';
  int _categoryColor = 0xFF2196F3;
  int _categoryIconCodePoint = Icons.category.codePoint;

  String _priority = 'medium';

  final List<String> recurrenceOptions = ['none', 'daily', 'weekly', 'monthly'];

  String selectedRecurrence = 'none';

  bool _reminderEnabled = true;
  int _reminderMinutesBefore = 10;

  final List<String> _attachments = [];

  @override
  void initState() {
    super.initState();
    _dueDate = widget.prefilledDate;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        _attachments.add(file.path);
      });
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null &&
        result.files.isNotEmpty &&
        result.files.first.path != null) {
      setState(() {
        _attachments.add(result.files.first.path!);
      });
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

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'low':
        return Colors.green;

      case 'medium':
        return Colors.orange;

      case 'high':
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task title is required')));
      return;
    }

    final now = DateTime.now();

    final task = Task(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      createdAt: now,
      updatedAt: now,
      dueDate: _dueDate,
      priority: _priorityToInt(_priority),
      color: _categoryColor,
      categoryId: _categoryId,
      categoryName: _categoryName,
      categoryColor: _categoryColor,
      categoryIconCodePoint: _categoryIconCodePoint,
      recurrence: selectedRecurrence,
      reminderMinutesBefore: _reminderEnabled ? _reminderMinutesBefore : 0,
      attachments: _attachments,
      tags: const [],
      subtasks: const [],
      progress: 0.0,
      isCompleted: false,
    );

    await context.read<TaskController>().addTask(task);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),

            const SizedBox(height: 12),

            ListTile(
              title: Text(
                _dueDate == null
                    ? 'Select Due Date'
                    : 'Due: ${_dueDate.toString().substring(0, 16)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (pickedDate == null) return;

                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (!mounted) return;

                if (pickedTime != null) {
                  setState(() {
                    _dueDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  });
                }
              },
            ),

            const SizedBox(height: 12),

            ListTile(
              title: Text('Category: $_categoryName'),
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
                    _categoryId = result.id;
                    _categoryName = result.name;
                    _categoryColor = result.color;
                    _categoryIconCodePoint = result.iconCodePoint;
                  });
                }
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: ['low', 'medium', 'high']
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _priorityColor(p),
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
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _priority = value;
                  });
                }
              },
            ),

            const SizedBox(height: 12),

            SwitchListTile(
              title: const Text('Enable Reminder'),
              value: _reminderEnabled,
              onChanged: (value) {
                setState(() {
                  _reminderEnabled = value;
                });
              },
            ),

            if (_reminderEnabled)
              DropdownButtonFormField<int>(
                initialValue: _reminderMinutesBefore,
                decoration: const InputDecoration(labelText: 'Reminder Time'),
                items: [5, 10, 15, 30, 60]
                    .map(
                      (m) => DropdownMenuItem(
                        value: m,
                        child: Text('$m minutes before'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _reminderMinutesBefore = value;
                    });
                  }
                },
              ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedRecurrence,
              decoration: const InputDecoration(labelText: 'Recurrence'),
              items: recurrenceOptions
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedRecurrence = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Attachments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 10),

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

            const SizedBox(height: 10),

            ..._attachments.map(
              (path) => ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(path.split('/').last),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Save Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
