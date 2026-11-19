import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/schedule_item_controller.dart';
import '../../domain/entities/schedule_item.dart';
import '../screens/add_schedule_item_screen.dart';

class ScheduleItemDetailsSheet extends StatelessWidget {
  final ScheduleItem item;

  const ScheduleItemDetailsSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              item.type.name
                  .replaceAll('personalEvent', 'Personal Event')
                  .replaceAll('subscription', 'Subscription')
                  .replaceAll('reminder', 'Reminder')
                  .replaceAll('task', 'Task'),
            ),

            const SizedBox(height: 12),

            Text(item.notes.isEmpty ? 'No notes' : item.notes),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  debugPrint('EDIT PRESSED: ${item.title}');

                  final navigator = Navigator.of(context, rootNavigator: true);

                  navigator.pop();

                  await Future.delayed(const Duration(milliseconds: 100));

                  debugPrint('ATTEMPTING NAVIGATION');

                  await navigator.push(
                    MaterialPageRoute(
                      builder: (_) => AddScheduleItemScreen(existingItem: item),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await context.read<ScheduleItemController>().deleteItem(
                    item.id,
                  );

                  if (!context.mounted) return;

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                label: const Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
