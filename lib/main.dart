import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:planup_fixed_new/features/schedule/domain/entities/schedule_item.dart';

import 'core/app/planup_app.dart';

import 'features/tasks/domain/entities/task.dart';
import 'features/category/domain/entities/category.dart';
import 'features/shifts/domain/entities/shift.dart';

import 'features/shifts/domain/entities/shift_template.dart';
import 'features/habits/domain/entities/habit.dart';

import 'shared/services/notification_service.dart';
import 'shared/services/error_logging_service.dart';
import 'shared/services/error_logger.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = ErrorLogger.logFlutterError;

      await Hive.initFlutter();

      await NotificationService.init();

      Hive.registerAdapter(TaskAdapter());
      Hive.registerAdapter(CategoryAdapter());
      Hive.registerAdapter(ShiftAdapter());
      Hive.registerAdapter(HabitAdapter());
      Hive.registerAdapter(ShiftTemplateAdapter());
      Hive.registerAdapter(ScheduleItemTypeAdapter());
      Hive.registerAdapter(ScheduleItemAdapter());

      await Hive.openBox<Task>('tasks');
      await Hive.openBox<Category>('categories');
      await Hive.openBox<Shift>('shifts');
      await Hive.openBox<ShiftTemplate>('shiftTemplates');
      await Hive.openBox<Habit>('habits');
      await Hive.openBox<ScheduleItem>('scheduleItems');

      runApp(const PlanUpApp());
    },
    (error, stackTrace) {
      ErrorLoggingService.logError(error, stackTrace);
    },
  );
}
