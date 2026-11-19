import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HabitProgressChart extends StatelessWidget {
  final List<DateTime> dates;

  const HabitProgressChart({super.key, required this.dates});

  @override
  Widget build(BuildContext context) {
    final spots = _buildSpots();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: spots.isNotEmpty ? spots.last.x : 1,
          minY: 0,
          maxY: spots.isNotEmpty ? spots.last.y + 1 : 1,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  List<FlSpot> _buildSpots() {
    if (dates.isEmpty) return [];

    final sorted = [...dates]..sort();
    final spots = <FlSpot>[];

    for (int i = 0; i < sorted.length; i++) {
      spots.add(FlSpot(i.toDouble(), i.toDouble()));
    }

    return spots;
  }
}
