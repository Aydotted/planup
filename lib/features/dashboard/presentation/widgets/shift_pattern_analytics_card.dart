import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';

class ShiftPatternAnalyticsCard extends StatefulWidget {
  const ShiftPatternAnalyticsCard({super.key});

  @override
  State<ShiftPatternAnalyticsCard> createState() =>
      _ShiftPatternAnalyticsCardState();
}

class _ShiftPatternAnalyticsCardState extends State<ShiftPatternAnalyticsCard> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarController>();

    final monthlyShifts =
        calendar.shifts
            .where(
              (shift) =>
                  shift.date.year == selectedMonth.year &&
                  shift.date.month == selectedMonth.month,
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    if (monthlyShifts.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Shift Pattern Analytics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('No shift data available.'),
            ],
          ),
        ),
      );
    }

    final shiftCounts = <String, int>{};

    for (final shift in monthlyShifts) {
      shiftCounts.update(
        shift.shiftType,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    String mostCommonShift = 'None';

    if (shiftCounts.isNotEmpty) {
      final sorted = shiftCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      mostCommonShift = sorted.first.key;
    }

    final nightShifts = monthlyShifts
        .where((e) => e.shiftType == 'Night')
        .length;

    final trainingDays = monthlyShifts
        .where((e) => e.shiftType == 'Training')
        .length;

    final leaveDays = monthlyShifts
        .where((e) => e.shiftType == 'Annual Leave')
        .length;

    final builtInTypes = {
      'Long Day',
      'Night',
      'Twilight',
      'Training',
      'Annual Leave',
      'Off',
    };

    final customShiftTypes = shiftCounts.keys
        .where((type) => !builtInTypes.contains(type))
        .length;

    int longestWorkStreak = 0;
    int currentWorkStreak = 0;

    DateTime? previousDate;

    for (final shift in monthlyShifts) {
      if (shift.shiftType == 'Off') {
        currentWorkStreak = 0;
        continue;
      }

      final currentDate = DateTime(
        shift.date.year,
        shift.date.month,
        shift.date.day,
      );

      if (previousDate == null) {
        currentWorkStreak = 1;
      } else {
        final difference = currentDate.difference(previousDate).inDays;

        if (difference == 1) {
          currentWorkStreak++;
        } else {
          currentWorkStreak = 1;
        }
      }

      if (currentWorkStreak > longestWorkStreak) {
        longestWorkStreak = currentWorkStreak;
      }

      previousDate = currentDate;
    }

    int longestNightStretch = 0;
    int currentNightStretch = 0;

    for (final shift in monthlyShifts) {
      if (shift.shiftType == 'Night') {
        currentNightStretch++;

        if (currentNightStretch > longestNightStretch) {
          longestNightStretch = currentNightStretch;
        }
      } else {
        currentNightStretch = 0;
      }
    }

    final weekdayCounts = <int, int>{};

    for (final shift in monthlyShifts) {
      weekdayCounts.update(
        shift.date.weekday,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    int mostWorkedWeekday = 1;

    if (weekdayCounts.isNotEmpty) {
      mostWorkedWeekday = weekdayCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
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
              'Shift Pattern Analytics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

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

            _metric('Most Common Shift', mostCommonShift),

            _metric('Most Worked Day', _weekdayName(mostWorkedWeekday)),

            _metric('Longest Work Streak', '$longestWorkStreak days'),

            _metric('Longest Night Run', '$longestNightStretch nights'),

            _metric('Night Shifts', '$nightShifts'),

            _metric('Training Days', '$trainingDays'),

            _metric('Leave Days', '$leaveDays'),

            _metric('Custom Shift Types', '$customShiftTypes'),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                longestNightStretch >= 3
                    ? 'Pattern detected: Multiple consecutive night shifts may require additional recovery time.'
                    : 'Shift pattern appears balanced this month.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _weekdayName(int day) {
    const weekdays = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return weekdays[day];
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
