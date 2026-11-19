import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:planup_fixed_new/core/routing/app_navigator.dart';
import 'package:planup_fixed_new/features/tasks/domain/entities/task.dart';
import 'package:planup_fixed_new/features/tasks/presentation/controllers/task_controller.dart';
import 'package:planup_fixed_new/shared/services/error_logger.dart';

class NotificationActionHandler {
  /// Handles notification taps
  static void handleTap(BuildContext context, String taskId) {
    try {
      final controller = Provider.of<TaskController>(context, listen: false);

      final Task? task = controller.tasks.cast<Task?>().firstWhere(
        (t) => t?.id == taskId,
        orElse: () => null,
      );

      if (task == null) return;

      AppNavigator.openTask(task);
    } catch (e, stack) {
      ErrorLogger.logCustom(
        'Failed to handle notification tap for taskId $taskId',
        error: e,
        stack: stack,
      );
    }
  }

  /// Handles action buttons
  static Future<void> handleAction(
    BuildContext context,
    String actionId,
    int taskHashCode,
  ) async {
    try {
      final controller = Provider.of<TaskController>(context, listen: false);

      final Task? task = controller.tasks.cast<Task?>().firstWhere(
        (t) => t?.id.hashCode == taskHashCode,
        orElse: () => null,
      );

      if (task == null) return;

      switch (actionId) {
        case 'MARK_DONE':
          await controller.toggleComplete(task);
          break;

        // Snooze functions are not currently implemented
        case 'SNOOZE_5':
        case 'SNOOZE_10':
        case 'SNOOZE_15':
        case 'SNOOZE_30':
          ErrorLogger.logCustom(
            'Snooze action requested but not implemented yet',
          );
          break;

        default:
          ErrorLogger.logCustom('Unknown notification action: $actionId');
      }
    } catch (e, stack) {
      ErrorLogger.logCustom(
        'Failed to handle notification action $actionId',
        error: e,
        stack: stack,
      );
    }
  }
}
