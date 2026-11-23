import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planup_fixed_new/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:planup_fixed_new/features/shifts/domain/entities/shift.dart';
import 'package:provider/provider.dart';
import 'package:planup_fixed_new/features/schedule/presentation/widgets/schedule_item_details_sheet.dart';

import 'package:planup_fixed_new/features/tasks/presentation/controllers/task_controller.dart';
import 'package:planup_fixed_new/features/category/presentation/controllers/category_controller.dart';
import 'package:planup_fixed_new/features/schedule/presentation/controllers/schedule_item_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String userMotivation = "Stay focused and take it one step at a time.";

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Color _getShiftColour(String shiftType) {
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

  Color getScheduleItemColor(String type) {
    switch (type) {
      case 'task':
        return Colors.blue;

      case 'reminder':
        return Colors.orange;

      case 'subscription':
        return Colors.purple;

      case 'personalEvent':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  IconData getScheduleItemIcon(String type) {
    switch (type) {
      case 'task':
        return Icons.task_alt;

      case 'reminder':
        return Icons.notifications;

      case 'subscription':
        return Icons.subscriptions;

      case 'personalEvent':
        return Icons.event;

      default:
        return Icons.notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskController>();
    final scheduleItems = context.watch<ScheduleItemController>().items;
    final calendar = context.watch<CalendarController>();
    final categoryController = context.watch<CategoryController>();

    final now = DateTime.now();

    final upcomingItems = scheduleItems.where((item) {
      final difference = item.dateTime.difference(now);

      return difference.inDays >= 0 && difference.inDays <= 7;
    }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // ------------------------------------------------------------
    // BUILD WEEKLY SHIFT MAP
    // ------------------------------------------------------------
    Map<String, Map<String, dynamic>> weeklyShift = {
      "Mon": {"abbr": "", "color": Colors.grey},
      "Tue": {"abbr": "", "color": Colors.grey},
      "Wed": {"abbr": "", "color": Colors.grey},
      "Thu": {"abbr": "", "color": Colors.grey},
      "Fri": {"abbr": "", "color": Colors.grey},
      "Sat": {"abbr": "", "color": Colors.grey},
      "Sun": {"abbr": "", "color": Colors.grey},
    };

    for (final shift in calendar.shifts) {
      try {
        final weekday = shift.date.weekday;

        dynamic category;

        try {
          category = categoryController.categories.firstWhere(
            (c) => c.id == shift.categoryId,
          );
        } catch (_) {
          category = null;
        }

        final abbr =
            shift.abbreviation ??
            category?.abbreviation ??
            shift.shiftType
                .split(' ')
                .map((w) => w[0])
                .take(2)
                .join()
                .toUpperCase();

        final shiftcolor = shift.colorValue != null
            ? Color(shift.colorValue!)
            : _getShiftColour(shift.shiftType);

        switch (weekday) {
          case DateTime.monday:
            weeklyShift["Mon"] = {"abbr": abbr, "color": shiftcolor};
            break;
          case DateTime.tuesday:
            weeklyShift["Tue"] = {"abbr": abbr, "color": shiftcolor};
            break;
          case DateTime.wednesday:
            weeklyShift["Wed"] = {"abbr": abbr, "color": shiftcolor};
            break;
          case DateTime.thursday:
            weeklyShift["Thu"] = {"abbr": abbr, "color": shiftcolor};
            break;
          case DateTime.friday:
            weeklyShift["Fri"] = {"abbr": abbr, "color": shiftcolor};
            break;
          case DateTime.saturday:
            weeklyShift["Sat"] = {"abbr": abbr, "color": shiftcolor};
            break;
          case DateTime.sunday:
            weeklyShift["Sun"] = {"abbr": abbr, "color": shiftcolor};
            break;
        }
      } catch (e, stackTrace) {
        debugPrint('weekly timeline error for ${shift.shiftType}:$e');
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    final hasShifts = weeklyShift.values.any(
      (s) => (s["abbr"] as String).isNotEmpty,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------------------------------------------------
                // HEADER
                // ------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/profile'),
                            child: const CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                color: Colors.indigo,
                                size: 30,
                              ),
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _weekdayName(now.weekday),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${now.day} ${_monthName(now.month)} ${now.year}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Welcome Back 👋",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ------------------------------------------------------------
                // TODAY'S FOCUS CARD
                // ------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () => _editMotivation(context),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Focus",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userMotivation,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ------------------------------------------------------------
                // NOTIFICATION CARD
                // ------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_active,
                          color: Colors.red,
                          size: 26,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Reminder: Your chosen shift or subscription expires soon.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ------------------------------------------------------------
                // WEEKLY SHIFT SECTION
                // ------------------------------------------------------------
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Weekly Timeline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: hasShifts
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _shiftPreview(
                                "Mon",
                                weeklyShift["Mon"]?["abbr"] ?? "",
                                weeklyShift["Mon"]?["color"] ?? Colors.grey,
                              ),
                              _shiftPreview(
                                "Tue",
                                weeklyShift["Tue"]?["abbr"] ?? "",
                                weeklyShift["Tue"]?["color"] ?? Colors.grey,
                              ),
                              _shiftPreview(
                                "Wed",
                                weeklyShift["Wed"]?["abbr"] ?? "",
                                weeklyShift["Wed"]?["color"] ?? Colors.grey,
                              ),
                              _shiftPreview(
                                "Thu",
                                weeklyShift["Thu"]?["abbr"] ?? "",
                                weeklyShift["Thu"]?["color"] ?? Colors.grey,
                              ),
                              _shiftPreview(
                                "Fri",
                                weeklyShift["Fri"]?["abbr"] ?? "",
                                weeklyShift["Fri"]?["color"] ?? Colors.grey,
                              ),
                              _shiftPreview(
                                "Sat",
                                weeklyShift["Sat"]?["abbr"] ?? "",
                                weeklyShift["Sat"]?["color"] ?? Colors.grey,
                              ),
                              _shiftPreview(
                                "Sun",
                                weeklyShift["Sun"]?["abbr"] ?? "",
                                weeklyShift["Sun"]?["color"] ?? Colors.grey,
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              "Your weekly shift overview will appear here once you add your shifts.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                if (upcomingItems.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Icon(Icons.upcoming, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Upcoming (7 Days)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: upcomingItems.length,
                      itemBuilder: (context, index) {
                        final item = upcomingItems[index];

                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) =>
                                  ScheduleItemDetailsSheet(item: item),
                            );
                          },
                          child: Container(
                            width: 220,
                            margin: const EdgeInsets.only(left: 20, right: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  decoration: BoxDecoration(
                                    color: getScheduleItemColor(item.type.name),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            getScheduleItemIcon(item.type.name),
                                            size: 18,
                                            color: getScheduleItemColor(
                                              item.type.name,
                                            ),
                                          ),

                                          const SizedBox(width: 6),

                                          Expanded(
                                            child: Text(
                                              item.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 10),

                                      Text(
                                        item.type.name
                                            .replaceAll(
                                              'personalEvent',
                                              'Personal Event',
                                            )
                                            .replaceAll(
                                              'subscription',
                                              'Subscription',
                                            )
                                            .replaceAll('reminder', 'Reminder')
                                            .replaceAll('task', 'Task'),
                                      ),

                                      const Spacer(),

                                      Text(
                                        getFriendlyDate(item.dateTime),
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],

                // ------------------------------------------------------------
                // TASK LIST SECTION
                // ------------------------------------------------------------
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: taskProvider.activeTasks.length,
                    itemBuilder: (_, index) {
                      final task = taskProvider.activeTasks[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/taskDetails',
                            arguments: task,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              // Color indicator
                              Container(
                                width: 10,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(task.color),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Task info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      task.dueDate == null
                                          ? "No due date"
                                          : "Due: ${task.dueDate!.toLocal().toString().split(" ").first}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Completion toggle
                              IconButton(
                                icon: Icon(
                                  task.isCompleted
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: task.isCompleted
                                      ? Colors.green
                                      : Colors.grey.shade600,
                                ),
                                onPressed: () {
                                  Provider.of<TaskController>(
                                    context,
                                    listen: false,
                                  ).toggleComplete(task);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ------------------------------------------------------------
                // BOTTOM NAVIGATION
                // ------------------------------------------------------------
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _navIcon(Icons.dashboard, '/dashboard'),
                      _navIcon(Icons.calendar_month, '/calendar'),
                      _navIcon(Icons.add_box, '/addSchedule'),
                      _navIcon(Icons.list, '/smartLists'),
                      _navIcon(Icons.local_fire_department, '/habits'),
                      _navIcon(Icons.settings, '/settings'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HELPERS
  // ------------------------------------------------------------

  String _monthName(int m) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[m - 1];
  }

  String _weekdayName(int w) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    return days[w - 1];
  }

  String _weekdayShort(int w) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[w - 1];
  }

  void _editMotivation(BuildContext context) {}

  Widget _shiftPreview(String day, String shift, Color color) {
    return Column(
      children: [
        Text(
          day,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            shift.isEmpty ? "-" : shift,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  String getFriendlyDate(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final itemDate = DateTime(date.year, date.month, date.day);

    final difference = itemDate.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Tomorrow';
    }

    if (difference > 1 && difference <= 7) {
      return 'In $difference Days';
    }

    const weekdays = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${weekdays[date.weekday]} '
        '${date.day} '
        '${months[date.month]}';
  }

  Widget _navIcon(IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
