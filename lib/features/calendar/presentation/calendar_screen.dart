import 'package:flutter/material.dart';
import 'package:planup_fixed_new/features/schedule/presentation/widgets/schedule_item_details_sheet.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:planup_fixed_new/features/shifts/domain/entities/shift.dart';
import 'package:planup_fixed_new/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:planup_fixed_new/features/schedule/presentation/screens/add_shift_screen.dart';
import 'package:planup_fixed_new/features/schedule/presentation/screens/add_schedule_item_screen.dart';
import 'package:planup_fixed_new/features/schedule/presentation/controllers/schedule_item_controller.dart';
import 'package:planup_fixed_new/features/schedule/domain/entities/schedule_item.dart';
import 'package:planup_fixed_new/features/shifts/presentation/widgets/shift_details_sheet.dart';

import '../../shifts/presentation/controllers/shift_template_controller.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Color getShiftColour(BuildContext context, String shiftType) {
    final templateController = context.read<ShiftTemplateController>();

    try {
      final customTemplate = templateController.templates.firstWhere(
        (template) => template.name == shiftType,
      );

      return Color(customTemplate.colourValue);
    } catch (_) {
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
  }

  String getShiftAbbreviation(BuildContext context, String shiftType) {
    final templateController = context.read<ShiftTemplateController>();

    try {
      final customTemplate = templateController.templates.firstWhere(
        (template) => template.name == shiftType,
      );

      return customTemplate.abbreviation;
    } catch (_) {
      switch (shiftType) {
        case 'Long Day':
          return 'LD';

        case 'Night':
          return 'N';

        case 'Twilight':
          return 'TW';

        case 'Training':
          return 'TR';

        case 'Annual Leave':
          return 'AL';

        case 'Off':
          return 'OFF';

        default:
          return '';
      }
    }
  }

  String formatTime(DateTime? time) {
    if (time == null) return '--:--';

    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
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

  Future<void> _showAddMenu(DateTime selectedDay) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'What would you like to add?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Shift'),
                onTap: () async {
                  Navigator.pop(context);

                  await Navigator.push(
                    this.context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddShiftScreen(prefilledDate: selectedDay),
                    ),
                  );

                  if (!mounted) return;

                  this.context.read<CalendarController>().init();
                },
              ),

              ListTile(
                leading: const Icon(Icons.task),
                title: const Text('Schedule Item'),
                onTap: () async {
                  Navigator.pop(context);

                  await Navigator.push(
                    this.context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddScheduleItemScreen(prefilledDate: selectedDay),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarController>();
    final scheduleItems = context.watch<ScheduleItemController>().items;

    final selectedDayShifts = calendar.shiftsForDate(_selectedDay);

    final selectedDayItems = scheduleItems.where((item) {
      return item.dateTime.year == _selectedDay.year &&
          item.dateTime.month == _selectedDay.month &&
          item.dateTime.day == _selectedDay.day;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar<Shift>(
            firstDay: DateTime(2020),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,

            selectedDayPredicate: (day) {
              return isSameDay(day, _selectedDay);
            },

            eventLoader: (day) {
              return calendar.shiftsForDate(day);
            },

            calendarBuilders: CalendarBuilders<Shift>(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) {
                  return null;
                }

                return Positioned(
                  bottom: 2,
                  left: 2,
                  right: 2,
                  child: Wrap(
                    spacing: 2,
                    runSpacing: 2,
                    alignment: WrapAlignment.center,
                    children: events.take(3).map((shift) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: getShiftColour(context, shift.shiftType),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          getShiftAbbreviation(context, shift.shiftType),
                          style: const TextStyle(
                            fontSize: 7,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },

            onDayLongPressed: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              _showAddMenu(selectedDay);
            },
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Selected Date: '
                  '${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const Spacer(),

                ElevatedButton.icon(
                  onPressed: () {
                    _showAddMenu(_selectedDay);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),

          const Divider(),

          Expanded(
            child: ListView(
              children: [
                if (selectedDayShifts.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Shifts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ...selectedDayShifts.map(
                    (shift) => GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => ShiftDetailsSheet(shift: shift),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: getShiftColour(
                              context,
                              shift.shiftType,
                            ),
                          ),
                          title: Text(shift.shiftType),
                          subtitle: Text(
                            '${formatTime(shift.startTime)} - '
                            '${formatTime(shift.endTime)}',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                if (selectedDayItems.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Schedule Items',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ...selectedDayItems
                      .map(
                        (item) => GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) =>
                                  ScheduleItemDetailsSheet(item: item),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: Icon(getScheduleItemIcon(item.type)),
                              title: Text(item.title),
                              subtitle: Text(
                                item.type.name
                                    .replaceAll(
                                      'personalEvent',
                                      'personal Evenet',
                                    )
                                    .replaceAll('subscription', 'Subscription')
                                    .replaceAll('reminder', 'Reminder')
                                    .replaceAll('task', 'Task'),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],

                if (selectedDayShifts.isEmpty && selectedDayItems.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text('Nothing scheduled for this date'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
