import 'package:flutter/material.dart';
import 'package:planup_fixed_new/features/dashboard/presentation/widgets/morning_briefing_card.dart';
import 'package:planup_fixed_new/features/dashboard/presentation/widgets/notification_preview_card.dart';
import 'package:planup_fixed_new/features/dashboard/presentation/widgets/recovery_trend_card.dart';
import 'package:planup_fixed_new/features/dashboard/presentation/widgets/task_shift_correlation_card.dart';
import 'package:provider/provider.dart';

import 'widgets/shift_summary_card.dart';
import 'widgets/workload_balance_card.dart';
import 'widgets/shift_analytics_card.dart';
import 'widgets/shift_productivity_card.dart';
import 'widgets/shift_pattern_analytics_card.dart';
import 'widgets/shift_trend_card.dart';
import 'widgets/todays_focus_card.dart';
import 'widgets/habit_analytics_card.dart';
import 'widgets/habit_shift_correlation_card.dart';
import 'widgets/recovery_status_card.dart';
import 'widgets/burnout_risk_card.dart';
import 'widgets/recommendation_card.dart';
import 'widgets/weekly_productivity_summary_card.dart';
import 'widgets/productivity_forecast_card.dart';
import 'widgets/scheduled_notifications_card.dart';
import 'widgets/daily_digest_card.dart';

import '../../tasks/presentation/controllers/task_controller.dart';
import '../../tasks/domain/entities/task.dart';
import '../../tasks/presentation/screens/smart_lists_screen.dart';
import '../../calendar/presentation/calendar_screen.dart';
import '../../search/presentation/search_screen.dart';
import '../../tasks/presentation/screens/sorting_screen.dart';
import '../../tasks/presentation/screens/task_details_screen.dart';

import '../../shifts/presentation/screens/shift_templates_list_screen.dart';
import 'shift_insights_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskController>();

    final today = provider.todayTasks;
    final overdue = provider.overdueTasks;
    final upcoming = provider.upcomingTasks;
    final pinned = provider.pinnedTasks;
    final completed = provider.completedTasks;

    final weeklyRate = provider.weeklyCompletionRate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.schedule),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShiftTemplatesListScreen(),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SortingScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalendarScreen()),
              );
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const TodaysFocusCard(),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Completion Rate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: weeklyRate.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(height: 8),
                Text(
                  '${(weeklyRate * 100).round()}% completed',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),

          //intelligence -Good Morning
          const MorningBriefingCard(),
          const SizedBox(height: 16),

          const DailyDigestCard(),
          const SizedBox(height: 16),

          const RecoveryStatusCard(),
          const SizedBox(height: 16),

          const RecoveryTrendCard(),
          const SizedBox(height: 16),

          const BurnoutRiskCard(),
          const SizedBox(height: 16),

          const ProductivityForecastCard(),
          const SizedBox(height: 16),

          const RecommendationCard(),
          const SizedBox(height: 16),

          const WeeklyProductivitySummaryCard(),
          const SizedBox(height: 32),

          //Analytics - why is this Happening
          const TaskShiftCorrelationCard(),
          const SizedBox(height: 16),

          const HabitShiftCorrelationCard(),
          const SizedBox(height: 16),

          const HabitAnalyticsCard(),
          const SizedBox(height: 16),

          const ShiftAnalyticsCard(),
          const SizedBox(height: 16),

          const ShiftInsightsCard(),
          const SizedBox(height: 16),

          const ShiftProductivityCard(),
          const SizedBox(height: 16),

          const ShiftPatternAnalyticsCard(),
          const SizedBox(height: 16),

          const ShiftTrendCard(),
          const SizedBox(height: 32),

          //Developer/Advanced Insight Features
          const NotificationPreviewCard(),
          const SizedBox(height: 16),

          const ScheduledNotificationsCard(),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  label: 'Today',
                  count: today.length,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SmartListsScreen(listType: 'today'),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _summaryCard(
                  label: 'Overdue',
                  count: overdue.length,
                  color: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SmartListsScreen(listType: 'overdue'),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _summaryCard(
                  label: 'Upcoming',
                  count: upcoming.length,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SmartListsScreen(listType: 'upcoming'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          _SectionHeader(
            title: 'Pinned',
            count: pinned.length,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SmartListsScreen(listType: 'pinned'),
                ),
              );
            },
          ),

          _TaskPreviewList(tasks: pinned),

          const SizedBox(height: 24),

          _SectionHeader(
            title: 'Today',
            count: today.length,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SmartListsScreen(listType: 'today'),
                ),
              );
            },
          ),

          _TaskPreviewList(tasks: today),

          const SizedBox(height: 24),

          _SectionHeader(
            title: 'Overdue',
            count: overdue.length,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SmartListsScreen(listType: 'overdue'),
                ),
              );
            },
          ),

          _TaskPreviewList(tasks: overdue),

          const SizedBox(height: 24),

          _SectionHeader(
            title: 'Upcoming',
            count: upcoming.length,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SmartListsScreen(listType: 'upcoming'),
                ),
              );
            },
          ),

          _TaskPreviewList(tasks: upcoming),

          const SizedBox(height: 24),

          _SectionHeader(
            title: 'Completed',
            count: completed.length,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SmartListsScreen(listType: 'completed'),
                ),
              );
            },
          ),

          _TaskPreviewList(tasks: completed),
        ],
      ),
    );
  }

  static Widget _summaryCard({
    required String label,
    required int count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title ($count)',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(onPressed: onTap, child: const Text('View All')),
      ],
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
        padding: EdgeInsets.only(top: 8),
        child: Text('No tasks here.', style: TextStyle(fontSize: 16)),
      );
    }

    return Column(
      children: tasks.take(3).map((task) {
        final color = Color(task.categoryColor);

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.category, color: color),
            ),
            title: Text(task.title),
            subtitle: task.dueDate != null
                ? Text(
                    'Due: ${task.dueDate!.toLocal().toString().split(' ').first}',
                  )
                : null,
            trailing: IconButton(
              icon: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
              onPressed: () async {
                await context.read<TaskController>().toggleComplete(task);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetailsScreen(task: task),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
