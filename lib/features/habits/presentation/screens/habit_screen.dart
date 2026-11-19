import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/habit_controller.dart';
import '../../domain/entities/habit.dart';
import 'add_habit_screen.dart';

class HabitScreen extends StatelessWidget {
  const HabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitProvider>().allHabits;

    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
        },
      ),
      body: habits.isEmpty
          ? const Center(child: Text('No habits yet.'))
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final Habit habit = habits[index];

                return ListTile(
                  leading: Icon(
                    IconData(habit.iconCode, fontFamily: 'MaterialIcons'),
                    color: Color(habit.color),
                  ),
                  title: Text(habit.name),
                  subtitle: Text('Streak: ${habit.streak}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.check_circle),
                    onPressed: () {
                      context.read<HabitProvider>().toggleHabit(habit);
                    },
                  ),
                );
              },
            ),
    );
  }
}
