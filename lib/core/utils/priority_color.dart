import 'package:flutter/material.dart';

class PriorityColor {
  static Color getColor(int priority) {
    switch (priority) {
      case 2:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 0:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
