import 'package:flutter/foundation.dart' hide Category;
import 'package:hive/hive.dart';

import '../../../category/domain/entities/category.dart';

class CategoryController extends ChangeNotifier {
  final Box<Category> _box = Hive.box<Category>('categories');

  List<Category> get categories => _box.values.toList();

  static bool get isSyncing => false;

  Future<void> addCategory(Category category) async {
    await _box.put(category.id, category);
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    await _box.put(category.id, category);
    notifyListeners();
  }

  Category? getById(String? id) {
    if (id == null) return null;

    try {
      return _box.values.firstWhere((category) => category.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<void> fullSync() async {}
}
