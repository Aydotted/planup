import 'package:flutter/material.dart';

class OverdueHelper {
  static bool isOverdue(DateTime dueDate, bool completed) {
    if (completed) return false;
    return dueDate.isBefore(DateTime.now());
  }

  static Color getOverdueColor(bool overdue) {
    return overdue ? Colors.red : Colors.black;
  }

  static String getOverdueLabel(bool overdue) {
    return overdue ? 'OVERDUE' : '';
  }
}
