import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../shifts/domain/entities/shift.dart';
import '../../../shifts/domain/entities/shift_template.dart';
import '../../../shifts/presentation/controllers/shift_template_controller.dart';

class AddShiftScreen extends StatefulWidget {
  final Shift? existingShift;
  final DateTime prefilledDate;

  const AddShiftScreen({
    super.key,
    this.existingShift,
    required this.prefilledDate,
  });

  @override
  State<AddShiftScreen> createState() => _AddShiftScreenState();
}

class _AddShiftScreenState extends State<AddShiftScreen> {
  late DateTime selectedDate;

  String selectedShiftType = 'Long Day';
  ShiftTemplate? selectedTemplate;

  TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 20, minute: 0);

  final List<String> shiftTypes = [
    'Long Day',
    'Night',
    'Twilight',
    'Training',
    'Annual Leave',
    'Off',
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.prefilledDate;

    if (widget.existingShift != null) {
      selectedDate = widget.existingShift!.date;

      selectedShiftType = widget.existingShift!.shiftType;

      if (widget.existingShift!.startTime != null) {
        startTime = TimeOfDay(
          hour: widget.existingShift!.startTime!.hour,
          minute: widget.existingShift!.startTime!.minute,
        );
      }

      if (widget.existingShift!.endTime != null) {
        endTime = TimeOfDay(
          hour: widget.existingShift!.endTime!.hour,
          minute: widget.existingShift!.endTime!.minute,
        );
      }
    }
  }

  void applyShiftTemplate(String value) {
    switch (value) {
      case 'Long Day':
        startTime = const TimeOfDay(hour: 8, minute: 0);
        endTime = const TimeOfDay(hour: 20, minute: 0);
        break;

      case 'Night':
        startTime = const TimeOfDay(hour: 20, minute: 0);
        endTime = const TimeOfDay(hour: 8, minute: 0);
        break;

      case 'Twilight':
        startTime = const TimeOfDay(hour: 12, minute: 0);
        endTime = const TimeOfDay(hour: 22, minute: 0);
        break;

      case 'Training':
        startTime = const TimeOfDay(hour: 9, minute: 0);
        endTime = const TimeOfDay(hour: 17, minute: 0);
        break;

      case 'Annual Leave':
      case 'Off':
        startTime = const TimeOfDay(hour: 0, minute: 0);
        endTime = const TimeOfDay(hour: 0, minute: 0);
        break;
    }
  }

  void applyCustomTemplate(ShiftTemplate template) {
    selectedTemplate = template;

    startTime = TimeOfDay(
      hour: template.startHour,
      minute: template.startMinute,
    );

    endTime = TimeOfDay(hour: template.endHour, minute: template.endMinute);

    selectedShiftType = template.name;
  }

  Future<void> showCreateTemplateDialog() async {
    final nameController = TextEditingController();
    final abbreviationController = TextEditingController();

    Color selectedColor = Colors.blue;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text('Create Custom Shift'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Shift Name',
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: abbreviationController,
                      decoration: const InputDecoration(
                        labelText: 'Abbreviation',
                      ),
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      children:
                          [
                            Colors.blue,
                            Colors.green,
                            Colors.orange,
                            Colors.red,
                            Colors.purple,
                            Colors.teal,
                          ].map((color) {
                            return GestureDetector(
                              onTap: () {
                                dialogSetState(() {
                                  selectedColor = color;
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: color,
                                child: selectedColor == color
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) {
                      return;
                    }

                    final template = ShiftTemplate(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text.trim(),
                      abbreviation: abbreviationController.text.trim(),
                      colourValue: selectedColor.toARGB32(),
                      startHour: startTime.hour,
                      startMinute: startTime.minute,
                      endHour: endTime.hour,
                      endMinute: endTime.minute,
                    );

                    await context.read<ShiftTemplateController>().addTemplate(
                      template,
                    );

                    final box = Hive.box<ShiftTemplate>('shiftTemplate');

                    debugPrint('Template in Hive after save: ${box.length}');

                    if (!mounted) return;

                    setState(() {
                      applyCustomTemplate(template);
                    });

                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String format24Hour(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Future<void> saveShift() async {
    final shiftStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startTime.hour,
      startTime.minute,
    );

    final shiftEnd = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      endTime.hour,
      endTime.minute,
    );

    final newShift = Shift(
      id:
          widget.existingShift?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),

      date: selectedDate,
      categoryId: selectedShiftType,
      shiftType: selectedShiftType,
      startTime: shiftStart,
      endTime: shiftEnd,
      notes: '',
      colorValue: selectedTemplate?.colourValue,
      abbreviation: selectedTemplate?.abbreviation,
    );

    if (widget.existingShift != null) {
      widget.existingShift!.date = newShift.date;

      widget.existingShift!.categoryId = newShift.categoryId;

      widget.existingShift!.shiftType = newShift.shiftType;

      widget.existingShift!.startTime = newShift.startTime;

      widget.existingShift!.endTime = newShift.endTime;

      widget.existingShift!.notes = newShift.notes;

      widget.existingShift!.colorValue = newShift.colorValue;

      widget.existingShift!.abbreviation = newShift.abbreviation;

      await context.read<CalendarController>().updateShift(
        widget.existingShift!,
      );
    } else {
      await context.read<CalendarController>().addShift(newShift);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final templateController = context.watch<ShiftTemplateController>();

    final customTemplates = templateController.templates;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Shift')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Date'),
              subtitle: Text(
                '${selectedDate.day.toString().padLeft(2, '0')}/'
                '${selectedDate.month.toString().padLeft(2, '0')}/'
                '${selectedDate.year}',
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: shiftTypes.contains(selectedShiftType)
                  ? selectedShiftType
                  : null,
              decoration: const InputDecoration(
                labelText: 'Built-In Shift Type',
                border: OutlineInputBorder(),
              ),
              items: shiftTypes.map((shift) {
                return DropdownMenuItem(value: shift, child: Text(shift));
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedTemplate = null;
                  selectedShiftType = value;
                  applyShiftTemplate(value);
                });
              },
            ),

            const SizedBox(height: 16),

            if (customTemplates.isNotEmpty)
              DropdownButtonFormField<ShiftTemplate>(
                decoration: const InputDecoration(
                  labelText: 'Custom Templates',
                  border: OutlineInputBorder(),
                ),
                items: customTemplates.map((template) {
                  return DropdownMenuItem<ShiftTemplate>(
                    value: template,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 6,
                          backgroundColor: Color(template.colourValue),
                        ),
                        const SizedBox(width: 8),
                        Text(template.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (template) {
                  if (template == null) {
                    return;
                  }

                  setState(() {
                    applyCustomTemplate(template);
                  });
                },
              ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: showCreateTemplateDialog,
              icon: const Icon(Icons.add),
              label: const Text('Create Custom Shift'),
            ),

            const SizedBox(height: 20),

            ListTile(
              title: const Text('Start Time'),
              subtitle: Text(format24Hour(startTime)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: startTime,
                );

                if (time != null) {
                  setState(() {
                    startTime = time;
                  });
                }
              },
            ),

            ListTile(
              title: const Text('End Time'),
              subtitle: Text(format24Hour(endTime)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: endTime,
                );

                if (time != null) {
                  setState(() {
                    endTime = time;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveShift,
                child: const Text('Save Shift'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
