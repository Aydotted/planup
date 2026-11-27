import 'package:flutter/material.dart';
import 'package:planup_fixed_new/features/shifts/presentation/controllers/shift_template_controller.dart';
import 'package:provider/provider.dart';

import 'package:planup_fixed_new/core/routing/app_navigator.dart';

// Controllers
import 'package:planup_fixed_new/features/tasks/presentation/controllers/task_controller.dart';
import 'package:planup_fixed_new/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:planup_fixed_new/features/category/presentation/controllers/category_controller.dart';
import 'package:planup_fixed_new/features/profile/presentation/profile_screen.dart';
import 'package:planup_fixed_new/features/settings/presentation/theme_customisation_screen.dart';

// Routing / Screens
import 'package:planup_fixed_new/core/routing/home_screen.dart';
import 'package:planup_fixed_new/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:planup_fixed_new/features/tasks/presentation/screens/task_details_screen.dart';
import 'package:planup_fixed_new/features/tasks/presentation/screens/smart_lists_screen.dart';
import 'package:planup_fixed_new/features/calendar/presentation/calendar_screen.dart';
import 'package:planup_fixed_new/features/schedule/presentation/screens/add_shift_screen.dart';
import 'package:planup_fixed_new/features/dashboard/presentation/dashboard_screen.dart';
import 'package:planup_fixed_new/features/settings/presentation/settings_screen.dart';
import 'package:planup_fixed_new/features/settings/category_manager_screen.dart';
import 'package:planup_fixed_new/features/habits/presentation/controllers/habit_controller.dart';
import 'package:planup_fixed_new/features/habits/presentation/screens/habit_screen.dart';
import 'package:planup_fixed_new/features/schedule/presentation/controllers/schedule_item_controller.dart';
// Domain entities
import 'package:planup_fixed_new/features/tasks/domain/entities/task.dart';

class PlanUpApp extends StatelessWidget {
  const PlanUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskController()..init()),

        ChangeNotifierProvider(
          create: (_) {
            final controller = CalendarController();
            controller.init();
            return controller;
          },
        ),

        ChangeNotifierProvider(create: (_) => ScheduleItemController()),

        ChangeNotifierProvider(create: (_) => HabitProvider()),

        ChangeNotifierProvider(create: (_) => CategoryController()..init()),
        ChangeNotifierProvider(
          create: (_) {
            debugPrint('SHIFT TEMPLATE CONTROLLER CREATED');
            final controller = ShiftTemplateController();
            controller.init();
            return controller;
          },
        ),
      ],

      child: MaterialApp(
        navigatorKey: AppNavigator.navigatorKey,
        title: 'PlanUp',
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (_) => const HomeScreen(),
          '/addTask': (_) => const AddTaskScreen(),
          '/taskDetails': (context) {
            final task = ModalRoute.of(context)!.settings.arguments as Task;
            return TaskDetailsScreen(task: task);
          },
          '/addSchedule': (_) => AddShiftScreen(prefilledDate: DateTime.now()),
          '/calendar': (_) => const CalendarScreen(),
          '/dashboard': (_) => const DashboardScreen(),
          '/habits': (_) => const HabitScreen(),
          '/settings': (_) => SettingsScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/themeSettings': (_) => const ThemeCustomisationScreen(),
          '/smartLists': (_) => const SmartListsScreen(listType: 'today'),
          '/categoryManager': (_) => const CategoryManagerScreen(),
        },
        initialRoute: '/home',
      ),
    );
  }
}
