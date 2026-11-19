import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../shifts/domain/entities/shift.dart';

class ShiftController extends ChangeNotifier {
  final Box<Shift> _box = Hive.box<Shift>('shifts');

  List<Shift> get shifts => _box.values.toList();

  Future<void> addShift(Shift shift) async {
    await _box.add(shift);

    notifyListeners();
  }

  Future<void> updateShift(int index, Shift shift) async {
    await _box.putAt(index, shift);

    notifyListeners();
  }

  Future<void> deleteShift(int index) async {
    await _box.deleteAt(index);

    notifyListeners();
  }

  List<Shift> shiftsForDate(DateTime date) {
    return shifts.where((s) {
      return s.date.year == date.year &&
          s.date.month == date.month &&
          s.date.day == date.day;
    }).toList();
  }
}
