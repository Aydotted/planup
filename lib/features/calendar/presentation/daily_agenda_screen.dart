import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tasks/presentation/controllers/task_controller.dart';
import '../../tasks/domain/entities/task.dart';
import '../../shifts/domain/entities/shift.dart';
import '../../calendar/presentation/controllers/calendar_controller.dart';
import '../../schedule/presentation/controllers/schedule_item_controller.dart';
import '../../schedule/domain/entities/schedule_item.dart';
import '../../schedule/presentation/screens/add_shift_screen.dart';
import '../../schedule/presentation/widgets/schedule_item_details_sheet.dart';
import '../../shifts/presentation/widgets/shift_details_sheet.dart';

import '../../tasks/presentation/screens/task_details_screen.dart';
import '../../tasks/presentation/screens/add_task_screen.dart';

class DailyAgendaScreen extends StatelessWidget {
  final DateTime date;

  const DailyAgendaScreen({super.key, required this.date});

  Color getShiftColor(String shiftType) {
    switch (shiftType) {
      case 'Long Day':
        return Colors.blue;

      case 'Night':
        return Colors.deepPurple;

      case 'Twilight':
        return Colors.orange;

      case 'Training':
        return Colors.green;

      case 'Annual Leave':
        return Colors.red;

      case 'Off':
        return Colors.grey;

      default:
        return Colors.blueGrey;
    }
  }

  String formatTime(DateTime? value) {
    if (value == null) {
      return '--:--';
    }

    return '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}';
  }

  IconData getScheduleItemIcon(ScheduleItemType type) {
    switch (type) {
      case ScheduleItemType.task:
        return Icons.task;

      case ScheduleItemType.reminder:
        return Icons.notifications;

      case ScheduleItemType.subscription:
        return Icons.subscriptions;

      case ScheduleItemType.personalEvent:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksProvider = context.watch<TaskController>();

    final calendar = context.watch<CalendarController>();

    final scheduleItems = context.watch<ScheduleItemController>().items;

    final normalized = DateTime(date.year, date.month, date.day);

    final List<Shift> shifts = calendar.shiftsForDate(normalized);

    final List<Task> tasks = tasksProvider.tasksForDate(normalized);

    final selectedDayItems = scheduleItems.where((item) {
      return item.dateTime.year == normalized.year &&
          item.dateTime.month == normalized.month &&
          item.dateTime.day == normalized.day;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${normalized.day}/${normalized.month}/${normalized.year}'),
        backgroundColor: Colors.blue.shade700,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add_task),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(prefilledDate: normalized),
            ),
          );
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              leading: Icon(Icons.access_time, color: Colors.blue.shade700),
              title: Text(
                shifts.isEmpty
                    ? 'No Shifts'
                    : '${shifts.length} Shift${shifts.length == 1 ? '' : 's'}',
              ),
              subtitle: const Text('Tap to manage shifts'),
              children: [
                if (shifts.isEmpty)
                  ListTile(
                    title: const Text('No shifts scheduled'),
                    trailing: const Icon(Icons.add),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddShiftScreen(prefilledDate: normalized),
                        ),
                      );
                    },
                  ),

                ...shifts.map(
                  (shift) => ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => ShiftDetailsSheet(shift: shift),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: getShiftColor(shift.shiftType),
                    ),
                    title: Text(shift.shiftType),
                    subtitle: Text(
                      '${formatTime(shift.startTime)} - '
                      '${formatTime(shift.endTime)}',
                    ),
                  ),
                ),
              ],
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              leading: const Icon(Icons.event_note),
              title: Text(
                selectedDayItems.isEmpty
                    ? 'No Schedule Items'
                    : '${selectedDayItems.length} Schedule Item${selectedDayItems.length == 1 ? '' : 's'}',
              ),
              subtitle: const Text(
                'Tasks, reminders, subscriptions and events',
              ),
              children: [
                if (selectedDayItems.isEmpty)
                  const ListTile(title: Text('No schedule items for this day')),

                ...selectedDayItems.map(
                  (item) => ListTile(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped ${item.title}')),
                      );

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => ScheduleItemDetailsSheet(item: item),
                      );
                    },
                    leading: Icon(getScheduleItemIcon(item.type)),
                    title: Text('TEST ${item.title}'),
                    subtitle: Text(item.type.name),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          if (tasks.isEmpty)
            const Text('No tasks for this day.', style: TextStyle(fontSize: 16))
          else
            ...tasks.map(
              (task) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) {
                      tasksProvider.toggleComplete(task);
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: task.dueDate != null
                      ? Text(
                          'Due: ${task.dueDate!.toLocal().toString().split(' ').first}',
                        )
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailsScreen(task: task),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
