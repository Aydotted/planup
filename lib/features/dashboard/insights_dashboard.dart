import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/tasks/presentation/controllers/task_controller.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';
import '../../features/category/presentation/controllers/category_controller.dart';
import '../../features/category/domain/entities/category.dart';

import '../../features/tasks/domain/entities/task.dart';

class InsightsDashboard extends StatelessWidget {
  const InsightsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskController>();
    final profileProvider = context.watch<ProfileController>();

    final tasks = taskProvider.tasks;
    final completed = tasks.where((t) => t.isCompleted).toList();
    final pending = tasks.where((t) => !t.isCompleted).toList();
    final overdue = tasks
        .where(
          (t) =>
              !t.isCompleted &&
              t.dueDate != null &&
              t.dueDate!.isBefore(DateTime.now()),
        )
        .toList();
    final upcoming = tasks
        .where(
          (t) =>
              !t.isCompleted &&
              t.dueDate != null &&
              t.dueDate!.isAfter(DateTime.now()),
        )
        .toList();

    final dailyGoal = profileProvider.profile?.dailyGoal ?? 0;
    final todayCompleted = completed
        .where(
          (t) =>
              // ignore: unnecessary_null_comparison
              t.updatedAt != null &&
              t.updatedAt.day == DateTime.now().day &&
              t.updatedAt.month == DateTime.now().month &&
              t.updatedAt.year == DateTime.now().year,
        )
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Insights Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, todayCompleted, dailyGoal),
            const SizedBox(height: 24),
            _buildStatsSection(
              completed.length,
              pending.length,
              overdue.length,
            ),
            const SizedBox(height: 24),
            _buildUpcomingSection(upcoming),
            const SizedBox(height: 24),
            _buildCategoryBreakdown(context, tasks),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int todayCompleted, int dailyGoal) {
    final progress = (todayCompleted / dailyGoal).clamp(0.0, 1.0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Productivity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 12),
            Text(
              '$todayCompleted / $dailyGoal tasks completed today',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(int completed, int pending, int overdue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statCard('Completed', completed, Colors.green),
            _statCard('Pending', pending, Colors.orange),
            _statCard('Overdue', overdue, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String title, int count, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSection(List<Task> upcoming) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Tasks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        if (upcoming.isEmpty) const Text('No upcoming tasks'),
        for (final task in upcoming.take(5))
          ListTile(
            title: Text(task.title),
            subtitle: Text(
              task.dueDate == null
                  ? 'No due date'
                  : 'Due: ${task.dueDate!.toLocal().toString().split(" ").first}',
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context, List<Task> tasks) {
    final categoryProvider = context.read<CategoryController>();
    final categories = categoryProvider.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category Breakdown',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        for (final cat in categories) _categoryTile(cat, tasks),
      ],
    );
  }

  Widget _categoryTile(Category cat, List<Task> tasks) {
    final count = tasks.where((t) => t.categoryId == cat.id).length;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(cat.color),
        child: const Icon(Icons.category, color: Colors.white),
      ),
      title: Text(cat.name),
      trailing: Text('$count tasks'),
    );
  }
}
