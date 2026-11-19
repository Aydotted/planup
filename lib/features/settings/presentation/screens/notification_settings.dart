import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/notification_settings_controller.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NotificationSettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Settings"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Enable Notifications"),
              value: controller.notificationsEnabled,
              onChanged: controller.toggleNotifications,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text("Reminder Minutes"),
              subtitle: Text("${controller.reminderMinutes} minutes"),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final minutes = await _pickMinutes(context);
                  if (minutes != null) {
                    controller.setReminderMinutes(minutes);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> _pickMinutes(BuildContext context) async {
    int selected = 0;

    return showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Set Reminder Minutes"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  value: selected.toDouble(),
                  min: 0,
                  max: 120,
                  divisions: 24,
                  label: "$selected",
                  onChanged: (v) => setState(() => selected = v.toInt()),
                ),
                Text("$selected minutes"),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, selected),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
