import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Controllers
import 'package:planup_fixed_new/features/tasks/presentation/controllers/task_controller.dart';
import 'package:planup_fixed_new/features/category/presentation/controllers/category_controller.dart';

// Screens
import 'package:planup_fixed_new/features/tasks/presentation/screens/task_screen.dart';
import 'package:planup_fixed_new/features/category/presentation/category_screen.dart';
import 'package:planup_fixed_new/features/calendar/presentation/calendar_screen.dart';
import 'package:planup_fixed_new/features/settings/presentation/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with TickerProviderStateMixin {
  int _index = 0;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  final List<Widget> screens = const [
    TasksScreen(),
    CategoryScreen(),
    CalendarScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;
      await context.read<TaskController>().init();
      if (!mounted) return;
      await context.read<CategoryController>().init();
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.97,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabSelected(int i) {
    setState(() => _index = i);

    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: ScaleTransition(scale: _scaleAnimation, child: screens[_index]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onTabSelected,
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
