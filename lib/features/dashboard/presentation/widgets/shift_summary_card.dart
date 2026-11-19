import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';

class ShiftSummaryCard extends StatefulWidget {
  const ShiftSummaryCard({super.key});

  @override
  State<ShiftSummaryCard> createState() => _ShiftSummaryCardState();
}

class _ShiftSummaryCardState extends State<ShiftSummaryCard> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarController>();

    final monthlyShifts = calendar.shifts
        .where(
          (shift) =>
              shift.date.year == selectedMonth.year &&
              shift.date.month == selectedMonth.month,
        )
        .toList();

    final Map<String, int> counts = {};

    for (final shift in monthlyShifts) {
      counts.update(shift.shiftType, (value) => value + 1, ifAbsent: () => 1);
    }

    final sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final mostUsed = sortedEntries.isNotEmpty ? sortedEntries.first : null;

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shift Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 30,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month - 1,
                      );
                    });
                  },
                ),

                Expanded(
                  child: Center(
                    child: Text(
                      '${_monthName(selectedMonth.month)} '
                      '${selectedMonth.year}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),

            const Divider(height: 24),

            if (sortedEntries.isEmpty)
              const Text('No shifts this month.')
            else
              ...sortedEntries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text(entry.key)),
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            const Divider(),

            Text(
              'Total Shifts: ${monthlyShifts.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            if (mostUsed != null) ...[
              const SizedBox(height: 8),

              Text(
                'Most Used: ${mostUsed.key}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month];
  }
}
