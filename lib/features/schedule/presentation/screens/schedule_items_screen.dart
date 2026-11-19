import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/schedule_item_controller.dart';

class ScheduleItemsScreen extends StatelessWidget {
  const ScheduleItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ScheduleItemController>().items;

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Items')),
      body: items.isEmpty
          ? const Center(child: Text('No schedule items'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.type.name),
                );
              },
            ),
    );
  }
}
