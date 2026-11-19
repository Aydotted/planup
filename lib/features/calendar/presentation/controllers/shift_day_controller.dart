import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../shifts/domain/entities/shift.dart';

class ShiftController extends ChangeNotifier {
  late Box<Shift> _box;

  Future<void> init() async {
    _box = Hive.box<Shift>('shifts');
  }

  Shift? getShiftForDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    try {
      return _box.values.firstWhere(
        (s) =>
            s.date.year == normalized.year &&
            s.date.month == normalized.month &&
            s.date.day == normalized.day,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveShift(Shift shift) async {
    await _box.add(shift);
    notifyListeners();
  }

  Future<void> deleteShift(DateTime date) async {
    final key = date.toIso8601String();
    if (_box.containsKey(key)) {
      await _box.delete(key);
      notifyListeners();
    }
  }

  List<Shift> shiftsForMonth(DateTime month) {
    return _box.values.where((s) {
      return s.date.year == month.year && s.date.month == month.month;
    }).toList();
  }
}
