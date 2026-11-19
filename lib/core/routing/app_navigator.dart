import 'package:flutter/material.dart';

import '../../features/tasks/domain/entities/task.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void openTask(Task task) {
    navigatorKey.currentState?.pushNamed('/taskDetails', arguments: task);
  }

  static void openAddTask() {
    navigatorKey.currentState?.pushNamed('/addTask');
  }

  static void openSmartList(String listType) {
    navigatorKey.currentState?.pushNamed('/smartLists', arguments: listType);
  }
}
