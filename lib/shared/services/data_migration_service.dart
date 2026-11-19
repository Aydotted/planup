import 'package:hive/hive.dart';

import 'package:planup_fixed_new/features/tasks/domain/entities/task.dart';
import 'package:planup_fixed_new/shared/services/error_logger.dart';

class DataMigrationService {
  static Future<void> migrate() async {
    try {
      final box = Hive.box<Task>('tasks');

      for (final task in box.values) {
        _migrateTask(task);
        await task.save();
      }
    } catch (e, stack) {
      ErrorLogger.logCustom('Data migration failed', error: e, stack: stack);
    }
  }

  static void _migrateTask(Task task) {
    try {
      task.notes ??= '';

      if (task.progress < 0) {
        task.progress = 0;
      }

      if (task.progress > 1) {
        task.progress = 1;
      }

      task.calculateProgress();

      task.updatedAt = DateTime.now();
    } catch (e, stack) {
      ErrorLogger.logCustom(
        'Task migration failed for task ${task.id}',
        error: e,
        stack: stack,
      );
    }
  }
}
