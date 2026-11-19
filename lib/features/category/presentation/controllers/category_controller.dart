import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/category.dart';

class CategoryController extends ChangeNotifier {
  late Box<Category> _categoryBox;

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get isSyncing => false;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _categoryBox = Hive.box<Category>('categories');

    _categories = _categoryBox.values.toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    await _categoryBox.put(category.id, category);

    _categories = _categoryBox.values.toList();

    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    await _categoryBox.put(category.id, category);

    _categories = _categoryBox.values.toList();

    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);

    _categories = _categoryBox.values.toList();

    notifyListeners();
  }

  Category? getById(String? id) {
    if (id == null) return null;

    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (_) {
      return null;
    }
  }

  Color getCategoryColor(String? categoryId) {
    final category = getById(categoryId);

    return Color(category?.color ?? 0xFF2196F3);
  }

  int getCategoryIconCode(String? categoryId) {
    final category = getById(categoryId);

    return category?.iconCodePoint ?? Icons.category.codePoint;
  }

  String getCategoryAbbreviation(String? categoryId) {
    return getById(categoryId)?.abbreviation ?? '';
  }
}
