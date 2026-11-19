import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'month_selector.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';

class ShiftAnalyticsCard extends StatefulWidget {
  const ShiftAnalyticsCard({super.key});

  @override
  State<ShiftAnalyticsCard> createState() => _ShiftAnalyticsCardState();
}

class _ShiftAnalyticsCardState extends State<ShiftAnalyticsCard> {
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

    double totalHours = 0;
    double longestShift = 0;

    final shiftTypes = <String>{};

    final shiftCounts = <String, int>{};
    int nightShifts = 0;
    int weekendShifts = 0;

    for (final shift in monthlyShifts) {
      shiftTypes.add(shift.shiftType);

      shiftCounts[shift.shiftType] = (shiftCounts[shift.shiftType] ?? 0) + 1;

      if (shift.shiftType == 'Night') {
        nightShifts++;
      }

      if (shift.date.weekday == DateTime.saturday ||
          shift.date.weekday == DateTime.sunday) {
        weekendShifts++;
      }

      if (shift.startTime != null && shift.endTime != null) {
        var duration = shift.endTime!.difference(shift.startTime!);

        if (duration.isNegative) {
          duration += const Duration(hours: 24);
        }

        final hours = duration.inMinutes / 60;

        totalHours += hours;

        if (hours > longestShift) {
          longestShift = hours;
        }
      }
    }

    final averageShift = monthlyShifts.isEmpty
        ? 0
        : totalHours / monthlyShifts.length;

    String mostUsedShift = 'None';

    if (shiftCounts.isNotEmpty) {
      final mostUsedEntry = shiftCounts.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      mostUsedShift = mostUsedEntry.key;
    }

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shift Analytics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            MonthSelector(
              label:
                  '${_monthName(selectedMonth.month)} '
                  '${selectedMonth.year}',

              onPrevious: () {
                setState(() {
                  selectedMonth = DateTime(
                    selectedMonth.year,
                    selectedMonth.month - 1,
                  );
                });
              },

              onNext: () {
                setState(() {
                  selectedMonth = DateTime(
                    selectedMonth.year,
                    selectedMonth.month + 1,
                  );
                });
              },
            ),
            const Divider(height: 24),

            _metricRow('Total Hours', totalHours.toStringAsFixed(1)),

            _metricRow(
              'Average Shift',
              '${averageShift.toStringAsFixed(1)} hrs',
            ),

            _metricRow(
              'Longest Shift',
              '${longestShift.toStringAsFixed(1)} hrs',
            ),

            _metricRow('Most Used Shift', mostUsedShift),
            _metricRow('Night Shifts', nightShifts.toString()),
            _metricRow('Weekend Shifts', weekendShifts.toString()),

            _metricRow('Shift Types', shiftTypes.length.toString()),

            _metricRow('Total Shifts', monthlyShifts.length.toString()),
          ],
        ),
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
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
