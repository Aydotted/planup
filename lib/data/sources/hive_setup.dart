import 'package:hive_flutter/hive_flutter.dart';
import 'package:planup_fixed_new/features/tasks/domain/entities/task.dart';
import 'package:planup_fixed_new/features/category/domain/entities/category.dart';
import 'package:planup_fixed_new/features/shifts/domain/entities/shift.dart';

class HiveSetup {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(ShiftAdapter());

    await Hive.openBox<Task>('tasks');
    await Hive.openBox<Category>('categories');
    await Hive.openBox<Shift>('shifts');
  }
}
