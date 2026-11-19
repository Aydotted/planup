import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile/presentation/controllers/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dailyGoalController;

  @override
  void initState() {
    super.initState();

    final profile = context.read<ProfileController>().profile;

    _nameController = TextEditingController(text: profile?.name ?? '');
    _dailyGoalController = TextEditingController(
      text: '${profile?.dailyGoal ?? 0}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProfileController>();
    final profile = provider.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _dailyGoalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Daily Task Goal',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final goal =
                    int.tryParse(_dailyGoalController.text.trim()) ?? 0;

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name cannot be empty')),
                  );
                  return;
                }

                provider.updateProfile(
                  name: name,
                  dailyGoal: goal,
                  notificationsEnabled: profile?.notificationsEnabled ?? false,
                );

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
