import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:planup_fixed_new/features/tasks/presentation/controllers/task_controller.dart';

class TaskDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskController>(context);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCard(
            title: 'Today',
            count: provider.todayCount,
            color: Colors.blue,
          ),
          _buildCard(
            title: 'Overdue',
            count: provider.overdueCount,
            color: Colors.red,
          ),
          _buildCard(
            title: 'Completed',
            count: provider.completedCount,
            color: Colors.green,
          ),
          _buildCard(
            title: 'Pending',
            count: provider.pendingCount,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required int count,
    required Color color,
  }) {
    return Container(
      width: 70,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.black)),
        ],
      ),
    );
  }
}
