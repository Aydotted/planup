import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/schedule_item.dart';

import '../../../../core/notifications/schedule_item_notification_scheduler.dart';

class ScheduleItemController extends ChangeNotifier {
  ScheduleItemController() {
    _items = _box.values.toList();
  }

  final Box<ScheduleItem> _box = Hive.box<ScheduleItem>('scheduleItems');

  final ScheduleItemNotificationScheduler _notificationScheduler =
      ScheduleItemNotificationScheduler();

  late final List<ScheduleItem> _items;

  List<ScheduleItem> get items => _items;

  Future<void> addItem(ScheduleItem item) async {
    await _box.put(item.id, item);

    await _notificationScheduler.schedule(item);

    _items.clear();

    _items.addAll(_box.values);

    debugPrint(
      'Schedule Item Saved: '
      '${item.title} '
      '(${item.type.name})',
    );

    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    final item = _box.get(id);

    if (item != null) {
      await _notificationScheduler.cancel(item);
    }

    await _box.delete(id);

    _items.clear();

    _items.addAll(_box.values);

    notifyListeners();
  }

  Future<void> updateItem(ScheduleItem item) async {
    await _box.put(item.id, item);

    await _notificationScheduler.schedule(item);

    _items.clear();

    _items.addAll(_box.values);

    notifyListeners();
  }
}
