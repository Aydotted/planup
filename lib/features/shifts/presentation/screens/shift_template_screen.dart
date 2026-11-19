import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../controllers/shift_template_controller.dart';
import '../../domain/entities/shift_template.dart';

class ShiftTemplateScreen extends StatefulWidget {
  final ShiftTemplate? template;

  const ShiftTemplateScreen({
    super.key,
    this.template,
  });

  @override
  State<ShiftTemplateScreen> createState() =>
      _ShiftTemplateScreenState();
}

class _ShiftTemplateScreenState
    extends State<ShiftTemplateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _abbreviationController =
      TextEditingController();

  Color selectedColor = Colors.blue;

  TimeOfDay startTime =
      const TimeOfDay(hour: 8, minute: 0);

  TimeOfDay endTime =
      const TimeOfDay(hour: 20, minute: 0);

  final List<Color> availableColors = [
    Colors.blue,
    Colors.deepPurple,
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();

    if (widget.template != null) {
      _nameController.text =
          widget.template!.name;

      _abbreviationController.text =
          widget.template!.abbreviation;

      selectedColor =
          Color(widget.template!.colourValue);

      startTime = TimeOfDay(
        hour: widget.template!.startHour,
        minute: widget.template!.startMinute,
      );

      endTime = TimeOfDay(
        hour: widget.template!.endHour,
        minute: widget.template!.endMinute,
      );
    }
  }

  Future<void> pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  Future<void> saveTemplate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller =
        context.read<ShiftTemplateController>();

    final template = ShiftTemplate(
      id: widget.template?.id ??
          const Uuid().v4(),
      name: _nameController.text.trim(),
      abbreviation:
          _abbreviationController.text.trim(),
      colourValue: selectedColor.value,
      startHour: startTime.hour,
      startMinute: startTime.minute,
      endHour: endTime.hour,
      endMinute: endTime.minute,
    );

    if (widget.template == null) {
      await controller.addTemplate(
        template,
      );
    } else {
      await controller.updateTemplate(
        template,
      );
    }

    if (!mounted) {
      return;
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing =
        widget.template != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'Edit Shift Template'
              : 'Create Shift Template',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(
                  labelText: 'Shift Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter a shift name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller:
                    _abbreviationController,
                decoration:
                    const InputDecoration(
                  labelText: 'Abbreviation',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter an abbreviation';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Colour',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                children: availableColors
                    .map((color) {
                  final selected =
                      selectedColor.value ==
                          color.value;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              ListTile(
                title: const Text(
                  'Start Time',
                ),
                subtitle: Text(
                  startTime.format(context),
                ),
                trailing: const Icon(
                  Icons.access_time,
                ),
                onTap: pickStartTime,
              ),

              ListTile(
                title: const Text(
                  'End Time',
                ),
                subtitle: Text(
                  endTime.format(context),
                ),
                trailing: const Icon(
                  Icons.access_time,
                ),
                onTap: pickEndTime,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(
                    isEditing
                        ? 'Update Template'
                        : 'Save Template',
                  ),
                  onPressed: saveTemplate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}