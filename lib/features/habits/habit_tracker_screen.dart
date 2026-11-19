import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/entities/habit.dart';
import 'presentation/controllers/habit_controller.dart';
import '../../shared/widgets/habit_progress_chart.dart';

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final habits = provider.allHabits;

    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),

      body: habits.isEmpty
          ? const Center(
              child: Text('No habits yet', style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: habits.length,
              itemBuilder: (_, index) {
                final habit = habits[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Color(habit.color),
                            child: Icon(Icons.category, color: Colors.white),
                          ),

                          title: Text(
                            habit.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          subtitle: Text(
                            'Streak: ${habit.streak} days\n'
                            'Longest: ${habit.longestStreak} days',
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle),
                                onPressed: () {
                                  provider.toggleHabit(habit);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  provider.deleteHabit(habit);
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Progress Chart
                        HabitProgressChart(dates: habit.completedDates),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    final controller = TextEditingController();
    final provider = context.read<HabitProvider>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Habit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Habit name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              final habit = Habit(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                color: Colors.blue.value,
                iconCode: Icons.check.codePoint,
                completedDates: [],
                streak: 0,
                longestStreak: 0,
                lastCompletedDate: null,
              );

              provider.addHabit(habit);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
