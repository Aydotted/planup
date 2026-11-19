import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';

class WorkloadBalanceCard extends StatefulWidget {
  const WorkloadBalanceCard({super.key});

  @override
  State<WorkloadBalanceCard> createState() =>
      _WorkloadBalanceCardState();
}

class _WorkloadBalanceCardState
    extends State<WorkloadBalanceCard> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarController>();

    final monthlyShifts = calendar.shifts.where(
      (shift) =>
          shift.date.year == selectedMonth.year &&
          shift.date.month == selectedMonth.month,
    ).toList();

    final workDays = monthlyShifts.where((shift) {
      return shift.shiftType != 'Off' &&
          shift.shiftType != 'Annual Leave';
    }).length;

    final offDays = monthlyShifts
        .where((shift) => shift.shiftType == 'Off')
        .length;

    final leaveDays = monthlyShifts
        .where(
          (shift) =>
              shift.shiftType == 'Annual Leave',
        )
        .length;

    final trainingDays = monthlyShifts
        .where(
          (shift) =>
              shift.shiftType == 'Training',
        )
        .length;

    final nightShifts = monthlyShifts
        .where(
          (shift) => shift.shiftType == 'Night',
        )
        .length;

    String balanceScore = 'Excellent';

    if (workDays > 24 || nightShifts > 10) {
      balanceScore = 'Poor';
    } else if (workDays > 20 || nightShifts > 7) {
      balanceScore = 'Fair';
    } else if (workDays > 16) {
      balanceScore = 'Good';
    }

    Color balanceColor = Colors.green;

    switch (balanceScore) {
      case 'Poor':
        balanceColor = Colors.red;
        break;

      case 'Fair':
        balanceColor = Colors.orange;
        break;

      case 'Good':
        balanceColor = Colors.blue;
        break;

      default:
        balanceColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Workload Balance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
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
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(
                    Icons.chevron_right,
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

            const Divider(),

            _metric(
              'Work Days',
              workDays.toString(),
            ),

            _metric(
              'Off Days',
              offDays.toString(),
            ),

            _metric(
              'Night Shifts',
              nightShifts.toString(),
            ),

            _metric(
              'Training Days',
              trainingDays.toString(),
            ),

            _metric(
              'Annual Leave',
              leaveDays.toString(),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    balanceColor.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Balance Score',
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    balanceScore,
                    style: TextStyle(
                      color: balanceColor,
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    Colors.indigo.withOpacity(0.08),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Text(
                _balanceInsight(
                  balanceScore,
                  workDays,
                  nightShifts,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _balanceInsight(
    String score,
    int workDays,
    int nightShifts,
  ) {
    switch (score) {
      case 'Poor':
        return 'This month shows a heavy workload. Consider scheduling additional recovery time.';

      case 'Fair':
        return 'Workload is manageable but trending high. Monitor fatigue levels carefully.';

      case 'Good':
        return 'Your workload appears balanced with adequate recovery opportunities.';

      default:
        return 'Excellent workload balance this month.';
    }
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