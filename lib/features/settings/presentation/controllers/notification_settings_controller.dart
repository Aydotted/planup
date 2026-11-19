import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NotificationSettingsController extends ChangeNotifier {
  late Box _box;

  bool _notificationsEnabled = true;
  int _reminderMinutes = 0;

  bool get notificationsEnabled => _notificationsEnabled;
  int get reminderMinutes => _reminderMinutes;

  Future<void> init() async {
    _box = Hive.box('settings');

    _notificationsEnabled = _box.get(
      'notificationsEnabled',
      defaultValue: true,
    );

    _reminderMinutes = _box.get('reminderMinutes', defaultValue: 0);

    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    _box.put('notificationsEnabled', value);
    notifyListeners();
  }

  void setReminderMinutes(int minutes) {
    _reminderMinutes = minutes;
    _box.put('reminderMinutes', minutes);
    notifyListeners();
  }
}
