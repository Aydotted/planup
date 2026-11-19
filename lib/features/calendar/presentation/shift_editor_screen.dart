import 'package:flutter/material.dart';

class ShiftEditorScreen extends StatefulWidget {
  final DateTime date;
  final String? currentShift;
  final Function(String newShift, String notes) onSave;

  const ShiftEditorScreen({
    Key? key,
    required this.date,
    required this.currentShift,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ShiftEditorScreen> createState() => _ShiftEditorScreenState();
}

class _ShiftEditorScreenState extends State<ShiftEditorScreen> {
  final List<String> shiftTypes = [
    'Long Day',
    'Night',
    'Twilight',
    'Off',
    'Free',
  ];

  late String selectedShift;
  String notes = '';

  @override
  void initState() {
    super.initState();
    selectedShift = widget.currentShift ?? 'Free';
  }

  Color shiftColor(String shift) {
    switch (shift) {
      case 'Long Day':
        return Colors.orange.shade300;
      case 'Night':
        return Colors.deepPurple.shade300;
      case 'Twilight':
        return Colors.blue.shade300;
      case 'Off':
        return Colors.green.shade300;
      case 'Free':
        return Colors.grey.shade400;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shift'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${widget.date.day}/${widget.date.month}/${widget.date.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text(
              'Select Shift',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            // Shift selector
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: shiftTypes.map((shift) {
                  return ListTile(
                    leading: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: shiftColor(shift),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    title: Text(shift),
                    trailing: selectedShift == shift
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedShift = shift;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Notes (optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add notes for this shift...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                notes = value;
              },
            ),

            const Spacer(),

            // Save button
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
                  widget.onSave(selectedShift, notes);
                  Navigator.pop(context);
                },
                child: const Text('Save Shift', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
