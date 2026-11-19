import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../features/tasks/presentation/controllers/task_controller.dart';
import '../../features/tasks/domain/entities/task.dart';

class CalendarPreview extends StatefulWidget {
  const CalendarPreview({super.key});

  @override
  State<CalendarPreview> createState() => _CalendarPreviewState();
}

class _CalendarPreviewState extends State<CalendarPreview> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TaskController>(context);
    final tasks = tasksProvider.tasks;

    Map<DateTime, List<Task>> events = {};

    for (final t in tasks) {
      if (t.dueDate == null) continue;
      final date = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
      events.putIfAbsent(date, () => []).add(t);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calendar Preview',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          TableCalendar<Task>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) =>
                _selectedDay != null &&
                day.year == _selectedDay!.year &&
                day.month == _selectedDay!.month &&
                day.day == _selectedDay!.day,
            eventLoader: (day) {
              final date = DateTime(day.year, day.month, day.day);
              return events[date] ?? [];
            },
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
                    .withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),

          const SizedBox(height: 16),

          if (_selectedDay != null)
            _buildSelectedDayTasks(events[_selectedDay!] ?? []),
        ],
      ),
    );
  }

  Widget _buildSelectedDayTasks(List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Text(
        'No tasks for this day.',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tasks',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...tasks.map(
          (t) => ListTile(
            dense: true,
            leading: Icon(
              Icons.circle,
              size: 12,
              color: Color(t.categoryColor),
            ),
            title: Text(t.title),
            subtitle:
                t.dueDate != null &&
                    !t.isCompleted &&
                    DateTime(
                      t.dueDate!.year,
                      t.dueDate!.month,
                      t.dueDate!.day,
                    ).isBefore(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      ),
                    )
                ? Text('Overdue', style: TextStyle(color: Colors.red.shade600))
                : null,
          ),
        ),
      ],
    );
  }
}
