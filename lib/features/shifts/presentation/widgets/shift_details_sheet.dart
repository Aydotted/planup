import 'package:flutter/material.dart';
import 'package:planup_fixed_new/features/schedule/presentation/screens/add_shift_screen.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/shift.dart';
import '../../../calendar/presentation/controllers/calendar_controller.dart';
import '../../../schedule/presentation/screens/add_shift_screen.dart';

class ShiftDetailsSheet extends StatelessWidget {
  final Shift shift;

  const ShiftDetailsSheet({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shift.shiftType,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text('${shift.date.day}/${shift.date.month}/${shift.date.year}'),

            const SizedBox(height: 12),

            Text('Start: ${shift.startTime}'),

            Text('End: ${shift.endTime}'),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final navigator = Navigator.of(context, rootNavigator: true);

                  Navigator.pop(context);

                  await navigator.push(
                    MaterialPageRoute(
                      builder: (_) => AddShiftScreen(
                        existingShift: shift,
                        prefilledDate: shift.date,
                      ),
                    ),
                  );
                },

                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await context.read<CalendarController>().deleteShift(shift);

                  if (!context.mounted) return;

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                label: const Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
