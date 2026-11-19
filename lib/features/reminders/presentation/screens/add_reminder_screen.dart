import 'package:flutter/material.dart';

class AddReminderScreen extends StatefulWidget {
  final DateTime? prefilledDate;

  const AddReminderScreen({super.key, this.prefilledDate});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  late DateTime selectedDate;

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    selectedDate = widget.prefilledDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Reminder')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),

            const SizedBox(height: 16),

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

            const SizedBox(height: 16),

            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
