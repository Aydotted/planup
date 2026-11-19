import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../features/calendar/presentation/controllers/calendar_controller.dart';
import '../../../../features/shifts/domain/entities/shift.dart';

class ShiftTrendCard extends StatefulWidget {
  const ShiftTrendCard({super.key});

  @override
  State<ShiftTrendCard> createState() => _ShiftTrendCardState();
}

class _ShiftTrendCardState extends State<ShiftTrendCard> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarController>();

    final currentMonthShifts = calendar.shifts
        .where(
          (shift) =>
              shift.date.year == selectedMonth.year &&
              shift.date.month == selectedMonth.month,
        )
        .toList();

    final previousMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);

    final previousMonthShifts = calendar.shifts
        .where(
          (shift) =>
              shift.date.year == previousMonth.year &&
              shift.date.month == previousMonth.month,
        )
        .toList();

    final currentHours = _totalHours(currentMonthShifts);
    final previousHours = _totalHours(previousMonthShifts);

    final currentNightShifts = currentMonthShifts
        .where((s) => s.shiftType == 'Night')
        .length;

    final previousNightShifts = previousMonthShifts
        .where((s) => s.shiftType == 'Night')
        .length;

    final totalShiftChange =
        currentMonthShifts.length - previousMonthShifts.length;

    final hoursChange = currentHours - previousHours;

    final nightShiftChange = currentNightShifts - previousNightShifts;

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shift Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
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
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.chevron_right),
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

            const Divider(),

            _trendRow(
              title: 'Hours Worked',
              current: '${currentHours.toStringAsFixed(1)} hrs',
              previous: '${previousHours.toStringAsFixed(1)} hrs',
              change:
                  '${hoursChange >= 0 ? '+' : ''}${hoursChange.toStringAsFixed(1)}',
            ),

            _trendRow(
              title: 'Total Shifts',
              current: '${currentMonthShifts.length}',
              previous: '${previousMonthShifts.length}',
              change: '${totalShiftChange >= 0 ? '+' : ''}$totalShiftChange',
            ),

            _trendRow(
              title: 'Night Shifts',
              current: '$currentNightShifts',
              previous: '$previousNightShifts',
              change: '${nightShiftChange >= 0 ? '+' : ''}$nightShiftChange',
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(_trendInsight(hoursChange, nightShiftChange)),
            ),
          ],
        ),
      ),
    );
  }

  double _totalHours(List<Shift> shifts) {
    double total = 0;

    for (final shift in shifts) {
      if (shift.startTime != null && shift.endTime != null) {
        var duration = shift.endTime!.difference(shift.startTime!);

        if (duration.isNegative) {
          duration += const Duration(hours: 24);
        }

        total += duration.inMinutes / 60;
      }
    }

    return total;
  }

  Widget _trendRow({
    required String title,
    required String current,
    required String previous,
    required String change,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(change),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(child: Text('Current: $current')),
              Text('Previous: $previous'),
            ],
          ),
        ],
      ),
    );
  }

  String _trendInsight(double hoursChange, int nightShiftChange) {
    if (hoursChange > 20) {
      return 'Your workload has increased significantly compared with last month.';
    }

    if (hoursChange < -20) {
      return 'Your workload has reduced compared with last month.';
    }

    if (nightShiftChange > 2) {
      return 'You are working more night shifts than last month.';
    }

    if (nightShiftChange < -2) {
      return 'You are working fewer night shifts than last month.';
    }

    return 'Your workload trend is stable compared with last month.';
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
