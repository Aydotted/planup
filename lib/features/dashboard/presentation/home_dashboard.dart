import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tasks/presentation/controllers/task_controller.dart';
import '../../tasks/domain/entities/task.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskController>();
    final todayTasks = taskProvider.todayTasks;
    final overdueTasks = taskProvider.overdueTasks;
    final upcomingTasks = taskProvider.upcomingTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PlanUp Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ Greeting
            Text(
              'Hello Ayo 👋',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Here’s your overview for today.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // ⭐ Quick Actions
            _QuickActions(),

            const SizedBox(height: 24),

            // ⭐ Today’s Tasks
            _SectionHeader(title: 'Today\'s Tasks'),
            _TaskPreviewList(tasks: todayTasks),

            const SizedBox(height: 24),

            // ⭐ Overdue Tasks
            _SectionHeader(title: 'Overdue'),
            _TaskPreviewList(tasks: overdueTasks),

            const SizedBox(height: 24),

            // ⭐ Upcoming Tasks
            _SectionHeader(title: 'Upcoming'),
            _TaskPreviewList(tasks: upcomingTasks),

            const SizedBox(height: 24),

            // ⭐ Smart Lists
            _SmartListsSection(),

            const SizedBox(height: 24),

            // ⭐ Habits Preview
            _HabitsPreview(),

            const SizedBox(height: 24),

            // ⭐ Calendar Preview
            _CalendarPreview(),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_task),
            label: const Text('Add Task'),
            onPressed: () {
              Navigator.pushNamed(context, '/editTask');
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: const Text('Calendar'),
            onPressed: () {
              Navigator.pushNamed(context, '/calendar');
            },
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _TaskPreviewList extends StatelessWidget {
  final List<Task> tasks;

  const _TaskPreviewList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('No tasks here.'),
      );
    }

    return Column(
      children: tasks.take(3).map((task) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.task_alt, color: Colors.blue),
            title: Text(task.title),
            subtitle: task.dueDate != null
                ? Text(
                    'Due: ${task.dueDate!.toLocal().toString().split(" ").first}',
                  )
                : null,
            onTap: () {
              Navigator.pushNamed(context, '/taskDetails', arguments: task);
            },
          ),
        );
      }).toList(),
    );
  }
}

class _SmartListsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Smart Lists'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SmartListButton(icon: Icons.today, label: 'Today', route: '/'),
            _SmartListButton(
              icon: Icons.warning,
              label: 'Overdue',
              route: '/smartLists',
            ),
            _SmartListButton(
              icon: Icons.upcoming,
              label: 'Upcoming',
              route: '/smartLists',
            ),
          ],
        ),
      ],
    );
  }
}

class _SmartListButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _SmartListButton({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}

class _HabitsPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Habits'),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: const Icon(Icons.check_circle),
          label: const Text('Open Habit Tracker'),
          onPressed: () {
            Navigator.pushNamed(context, '/habits');
          },
        ),
      ],
    );
  }
}

class _CalendarPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Calendar'),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: const Icon(Icons.calendar_month),
          label: const Text('View Calendar'),
          onPressed: () {
            Navigator.pushNamed(context, '/calendar');
          },
        ),
      ],
    );
  }
}
