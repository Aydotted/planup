import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/shift_template.dart';

class ShiftTemplateController extends ChangeNotifier {
  late Box<ShiftTemplate> _box;

  List<ShiftTemplate> _templates = [];

  List<ShiftTemplate> get templates => _templates;

  Future<void> init() async {
    debugPrint('SHIFT TEMPLATE INIT CALLED');

    _box = Hive.box<ShiftTemplate>('shiftTemplates');

    debugPrint('Templates loaded: ${_box.values.length}');

    _templates = _box.values.toList();

    notifyListeners();
  }

  Future<void> addTemplate(ShiftTemplate template) async {
    final box = Hive.box<ShiftTemplate>('shiftTemplates');

    await box.put(template.id, template);

    debugPrint('Templates after save: ${box.values.length}');

    _templates = box.values.toList();

    notifyListeners();
  }

  Future<void> updateTemplate(ShiftTemplate template) async {
    final box = Hive.box<ShiftTemplate>('shiftTemplates');

    await box.put(template.id, template);

    _templates = box.values.toList();

    notifyListeners();
  }

  Future<void> deleteTemplate(String id) async {
    final box = Hive.box<ShiftTemplate>('shiftTemplates');

    await box.delete(id);

    _templates = box.values.toList();

    notifyListeners();
  }

  Future<void> duplicateTemplate(ShiftTemplate template) async {
    final duplicate = ShiftTemplate(
      id: const Uuid().v4(),
      name: '${template.name} Copy',
      abbreviation: template.abbreviation,
      colourValue: template.colourValue,
      startHour: template.startHour,
      startMinute: template.startMinute,
      endHour: template.endHour,
      endMinute: template.endMinute,
    );

    await addTemplate(duplicate);
  }

  ShiftTemplate? findByName(String name) {
    try {
      return _templates.firstWhere((element) => element.name == name);
    } catch (_) {
      return null;
    }
  }
}
