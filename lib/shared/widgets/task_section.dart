import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:planup_fixed_new/features/tasks/domain/entities/task.dart';
import 'package:planup_fixed_new/features/tasks/presentation/controllers/task_controller.dart';
import 'package:planup_fixed_new/core/utils/priority_color.dart';
import 'package:planup_fixed_new/core/utils/overdue_helper.dart';
import 'package:planup_fixed_new/features/tasks/presentation/screens/edit_task_screen.dart';

class TaskSection extends StatelessWidget {
  final String title;
  final List<Task> tasks;

  const TaskSection({super.key, required this.title, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          ...tasks.map((task) {
            final overdue = task.dueDate != null
                ? OverdueHelper.isOverdue(task.dueDate!, task.isCompleted)
                : false;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Dismissible(
                key: Key(task.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                onDismissed: (_) {
                  context.read<TaskController>().deleteTask(task.id);
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  leading: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(task.categoryColor),
                        child: const Icon(Icons.category, color: Colors.white),
                      ),
                      if (task.recurrence != 'none')
                        const Positioned(
                          right: -4,
                          bottom: -4,
                          child: Icon(
                            Icons.repeat,
                            size: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                    ],
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: PriorityColor.getColor(task.priority),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (overdue)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'OVERDUE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Text(
                    'Priority ${task.priority}'
                    '${task.dueDate != null ? ' • Due ${task.dueDate.toString().substring(0, 16)}' : ''}'
                    '${task.recurrence != 'none' ? ' • ${task.recurrence.toUpperCase()}' : ''}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) {
                      context.read<TaskController>().toggleComplete(task);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTaskScreen(task: task),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
