import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tasks/presentation/controllers/task_controller.dart';
import '../../settings/presentation/controllers/category_controller.dart';
import '../../../shared/widgets/sync_status_indicator.dart';

class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<TaskController>(context);
    Provider.of<CategoryController>(context);

    final syncing = TaskController.isSyncing || CategoryController.isSyncing;

    return Scaffold(
      appBar: AppBar(title: Text('Cloud Sync')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SyncStatusIndicator(syncing: syncing),
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.sync),
              label: Text('Sync Now'),
              onPressed: () async {
                await TaskController.fullSync();
                await CategoryController.fullSync();
              },
            ),
          ],
        ),
      ),
    );
  }
}
