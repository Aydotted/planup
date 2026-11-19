import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';

import '../../services/recovery_score_service.dart';

class RecoveryStatusCard extends StatelessWidget {
  const RecoveryStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final shifts = context.watch<CalendarController>().shifts;

    debugPrint('Recovery Card Shifts: ${shifts.length}');

    final recovery = RecoveryScoreService.analyse(shifts);

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recovery Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text('Status: ${recovery.status}'),

            const SizedBox(height: 6),

            Text(
              'Estimated Load: '
              '${recovery.estimatedHours.toStringAsFixed(0)} hrs',
            ),

            const SizedBox(height: 6),

            Text(
              'Recommended Required: '
              '${recovery.recoveryDays.toStringAsFixed(1)} day(s)',
            ),

            const SizedBox(height: 6),

            Text('Recovery Debt: ${recovery.debt}'),
          ],
        ),
      ),
    );
  }
}
