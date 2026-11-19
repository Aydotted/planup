import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../calendar/presentation/controllers/calendar_controller.dart';

import '../../services/recovery_trend_service.dart';

class RecoveryTrendCard extends StatelessWidget {
  const RecoveryTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    final shifts = context.watch<CalendarController>().shifts;

    final trend = RecoveryTrendService.analyse(shifts);

    Color trendColor;

    switch (trend.trend) {
      case 'Improving':
        trendColor = Colors.green;
        break;

      case 'Declining':
        trendColor = Colors.red;
        break;

      default:
        trendColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recovery Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Text('Trend: '),
                Text(
                  trend.trend,
                  style: TextStyle(
                    color: trendColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Current Week Debt: '
              '${trend.currentDebt}',
            ),

            const SizedBox(height: 4),

            Text(
              'Previous Week Debt: '
              '${trend.previousDebt}',
            ),

            const SizedBox(height: 4),

            Text(
              'Difference: '
              '${trend.difference}',
            ),

            const Divider(),

            Text(
              '28-Day Load: '
              '${trend.monthlyLoad}',
            ),
          ],
        ),
      ),
    );
  }
}
