import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../shifts/domain/entities/shift.dart';

import '../../../../core/notifications/shift_notification_scheduler.dart';

class CalendarController extends ChangeNotifier {
  late Box<Shift> _shiftBox;

  List<Shift> _shifts = [];

  List<Shift> get shifts => _shifts;
  Shift? getShiftById(String id) {
    try {
      return _shifts.firstWhere((shift) => shift.id == id);
    } catch (_) {
      return null;
    }
  }

  final ShiftNotificationScheduler _notificationScheduler =
      ShiftNotificationScheduler();

  Future<void> init() async {
    _shiftBox = Hive.box<Shift>('shifts');
    _refresh();
  }

  void _refresh() {
    _shifts = _shiftBox.values.toList();
    notifyListeners();
  }

  Future<void> addShift(Shift shift) async {
    try {
      debugPrint('===== SAVING SHIFT =====');

      await _shiftBox.put(shift.id, shift);

      await _notificationScheduler.schedule(shift);

      debugPrint('Hive save successful');

      _refresh();

      debugPrint('Saved shifts count: ${_shifts.length}');
    } catch (e) {
      debugPrint('SHIFT SAVE ERROR: $e');
    }
  }

  Future<void> deleteShift(Shift shift) async {
    await _notificationScheduler.cancel(shift);

    await shift.delete();

    _refresh();
  }

  Future<void> updateShift(Shift shift) async {
    await shift.save();

    await _notificationScheduler.schedule(shift);

    _refresh();
  }

  List<Shift> shiftsForDate(DateTime date) {
    return _shifts.where((shift) {
      return shift.date.year == date.year &&
          shift.date.month == date.month &&
          shift.date.day == date.day;
    }).toList();
  }
}
