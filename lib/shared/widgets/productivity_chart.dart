import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../features/tasks/domain/entities/task.dart';

class ProductivityChart extends StatelessWidget {
  final List<Task> tasks;

  const ProductivityChart({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final data = _buildWeeklyData();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: data,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  return Text(days[value.toInt()]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildWeeklyData() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    final counts = List<int>.filled(7, 0);

    for (final task in tasks) {
      if (task.isCompleted) {
        final dayDiff = task.updatedAt.difference(startOfWeek).inDays;
        if (dayDiff >= 0 && dayDiff < 7) {
          counts[dayDiff]++;
        }
      }
    }

    return List.generate(
      7,
      (i) => BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: counts[i].toDouble(),
            color: Colors.blue,
            width: 14,
          ),
        ],
      ),
    );
  }
}
