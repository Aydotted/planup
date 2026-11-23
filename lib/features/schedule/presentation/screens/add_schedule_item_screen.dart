import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'schedule_items_screen.dart';
import '../controllers/schedule_item_controller.dart';
import '../../domain/entities/schedule_item.dart';

import '../../../../shared/services/error_logger.dart';

class AddScheduleItemScreen extends StatefulWidget {
  final DateTime? prefilledDate;

  final ScheduleItem? existingItem;

  const AddScheduleItemScreen({
    super.key,
    this.prefilledDate,
    this.existingItem,
  });

  @override
  State<AddScheduleItemScreen> createState() => _AddScheduleItemScreenState();
}

class _AddScheduleItemScreenState extends State<AddScheduleItemScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  bool notificationsEnabled = true;

  bool recurring = false;

  String recurrenceType = 'none';

  int reminderMinutesBefore = 30;

  String selectedType = 'Task';

  final List<String> itemTypes = [
    'Task',
    'Reminder',
    'Subscription',
    'Personal Event',
  ];

  Future<void> saveItem() async {
    final item = ScheduleItem(
      recurring: recurring,

      recurrenceType: recurrenceType,

      notificationsEnabled: notificationsEnabled,

      reminderMinutesBefore: reminderMinutesBefore,

      id:
          widget.existingItem?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      type: ScheduleItemType.values.firstWhere(
        (type) =>
            type.name.toLowerCase() ==
            selectedType.replaceAll(' ', '').toLowerCase(),
      ),
      title: titleController.text.trim(),
      notes: notesController.text.trim(),
      subtype: '',
      completed: false,
      dateTime: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
    );

    if (widget.existingItem != null) {
      await context.read<ScheduleItemController>().updateItem(item);

      ErrorLogger.logCustom(
        'Schedule item updated',
        error: Exception(
          'Type: ${item.type.name}, '
          'Title: ${item.title}',
        ),
      );
    } else {
      await context.read<ScheduleItemController>().addItem(item);

      ErrorLogger.logCustom(
        'Schedule item created',
        error: Exception(
          'Type: ${item.type.name}, '
          'Title: ${item.title}',
        ),
      );
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    selectedDate = widget.prefilledDate ?? DateTime.now();

    if (widget.existingItem != null) {
      switch (widget.existingItem!.type) {
        case ScheduleItemType.task:
          selectedType = 'Task';
          break;

        case ScheduleItemType.reminder:
          selectedType = 'Reminder';
          break;

        case ScheduleItemType.subscription:
          selectedType = 'Subscription';
          break;

        case ScheduleItemType.personalEvent:
          selectedType = 'Personal Event';
          break;
      }

      notificationsEnabled = widget.existingItem!.notificationsEnabled;

      reminderMinutesBefore = widget.existingItem!.reminderMinutesBefore;

      recurring = widget.existingItem!.recurring ?? false;

      recurrenceType = widget.existingItem!.recurrenceType ?? 'none';

      titleController.text = widget.existingItem!.title;

      notesController.text = widget.existingItem!.notes;

      selectedDate = widget.existingItem!.dateTime;

      selectedTime = TimeOfDay(
        hour: widget.existingItem!.dateTime.hour,
        minute: widget.existingItem!.dateTime.minute,
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScheduleItemsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: const InputDecoration(
                labelText: 'Item Type',
                border: OutlineInputBorder(),
              ),
              items: itemTypes.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedType = value;
                });
              },
            ),

            const SizedBox(height: 20),

            if (selectedType == 'Task') ...[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            if (selectedType == 'Reminder') ...[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                decoration: const InputDecoration(
                  labelText: 'Reminder Notes',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: recurrenceType == 'none'
                    ? 'Never'
                    : recurrenceType[0].toUpperCase() +
                          recurrenceType.substring(1),

                decoration: const InputDecoration(
                  labelText: 'Repeat',
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(value: 'Never', child: Text('Never')),
                  DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                  DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    if (value == 'Never') {
                      recurring = false;
                      recurrenceType = 'none';
                    } else {
                      recurring = true;
                      recurrenceType = value.toLowerCase();
                    }
                  });
                },
              ),
            ],

            if (selectedType == 'Subscription') ...[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Service Name',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Cost',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Renewal Frequency',
                  border: OutlineInputBorder(),
                ),
                initialValue: 'Monthly',
                items: const [
                  DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                  DropdownMenuItem(value: 'Yearly', child: Text('Yearly')),
                ],
                onChanged: (_) {},
              ),
            ],

            if (selectedType == 'Personal Event') ...[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 16),

            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              title: const Text('Date'),
              subtitle: Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
            ),

            ListTile(
              title: const Text('Time'),
              subtitle: Text(selectedTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );

                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),

            DropdownButtonFormField<int>(
              initialValue: reminderMinutesBefore,
              decoration: const InputDecoration(labelText: 'Reminder Before'),
              items: const [
                DropdownMenuItem(value: 15, child: Text('15 minutes')),
                DropdownMenuItem(value: 30, child: Text('30 minutes')),
                DropdownMenuItem(value: 60, child: Text('1 hour')),
                DropdownMenuItem(value: 90, child: Text('1 hour 30 minutes')),
                DropdownMenuItem(value: 120, child: Text('2 hours')),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  reminderMinutesBefore = value;
                });
              },
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveItem,
                child: Text('Save $selectedType'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
