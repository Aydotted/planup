import 'package:flutter/material.dart';

import '../../../tasks/domain/entities/task.dart';
import '../../domain/entities/subtask.dart';
import '../../../tasks/domain/usecases/get_tasks_usecase.dart';
import '../../../tasks/data/repositories/task_repository.dart';
import '../../../tasks/data/repositories/hive_task_repository.dart';

class TaskController extends ChangeNotifier {
  final TaskRepository _repository = HiveTaskRepository();

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  List<Task> get allTasks => _tasks;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await GetTasksUseCase(_repository).call();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _repository.addTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task updatedTask) async {
    await _repository.updateTask(updatedTask);

    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);

    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);

    _tasks.removeWhere((t) => t.id == id);

    notifyListeners();
  }

  Future<void> toggleSubtask(Task task, Subtask subtask) async {
    subtask.isCompleted = !subtask.isCompleted;

    task.calculateProgress();

    await updateTask(task);
  }

  Future<void> toggleComplete(Task task) async {
    task.isCompleted = !task.isCompleted;

    task.calculateProgress();
    task.updatedAt = DateTime.now();

    await updateTask(task);
  }

  Future<void> togglePinned(Task task) async {
    final updatedTask = task.copyWith(
      isPinned: !task.isPinned,
      updatedAt: DateTime.now(),
    );

    await updateTask(updatedTask);
  }

  Future<void> addTag(Task task, String tag) async {
    if (task.tags.contains(tag)) return;

    final updatedTask = task.copyWith(
      tags: [...task.tags, tag],
      updatedAt: DateTime.now(),
    );

    await updateTask(updatedTask);
  }

  Future<void> removeTag(Task task, String tag) async {
    final updatedTask = task.copyWith(
      tags: task.tags.where((t) => t != tag).toList(),
      updatedAt: DateTime.now(),
    );

    await updateTask(updatedTask);
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);

    if (index == -1) return;

    final task = _tasks[index];

    final updated = task.copyWith(
      isCompleted: !task.isCompleted,
      updatedAt: DateTime.now(),
    );

    updated.calculateProgress();

    _tasks[index] = updated;

    notifyListeners();
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Task> tasksForDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);

    return _tasks.where((t) {
      if (t.dueDate == null || t.deleted || t.isArchived) {
        return false;
      }

      final d = t.dueDate!;

      return d.year == normalized.year &&
          d.month == normalized.month &&
          d.day == normalized.day;
    }).toList();
  }

  List<Task> get activeTasks {
    return _tasks.where((t) => !t.deleted && !t.isArchived).toList()
      ..sort((a, b) {
        if (a.isPinned != b.isPinned) {
          return a.isPinned ? -1 : 1;
        }

        if (a.dueDate == null && b.dueDate != null) {
          return 1;
        }

        if (a.dueDate != null && b.dueDate == null) {
          return -1;
        }

        if (a.dueDate != null && b.dueDate != null) {
          return a.dueDate!.compareTo(b.dueDate!);
        }

        return a.createdAt.compareTo(b.createdAt);
      });
  }

  List<Task> get pinnedTasks =>
      _tasks.where((t) => t.isPinned && !t.deleted && !t.isArchived).toList();

  List<Task> get completedTasks =>
      _tasks.where((t) => t.isCompleted && !t.deleted).toList();

  List<Task> get todayTasks {
    return _tasks.where((t) {
      return !t.deleted && !t.isArchived && t.isDueToday && !t.isCompleted;
    }).toList();
  }

  List<Task> get overdueTasks {
    return _tasks.where((t) {
      return !t.deleted && !t.isArchived && t.isOverdue;
    }).toList();
  }

  List<Task> get upcomingTasks {
    return _tasks.where((t) {
      return !t.deleted && !t.isArchived && t.isUpcoming;
    }).toList();
  }

  double get weeklyCompletionRate {
    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));

    final relevant = _tasks.where((t) {
      if (t.dueDate == null || t.deleted || t.isArchived) {
        return false;
      }

      final d = t.dueDate!;

      final normalized = DateTime(d.year, d.month, d.day);

      return normalized.isAfter(start.subtract(const Duration(days: 1))) &&
          normalized.isBefore(now.add(const Duration(days: 1)));
    }).toList();

    if (relevant.isEmpty) {
      return 0.0;
    }

    final completed = relevant.where((t) => t.isCompleted).length.toDouble();

    return completed / relevant.length;
  }

  // Dashboard statistics

  int get totalCount => _tasks.where((t) => !t.deleted).length;

  int get todayCount => todayTasks.length;

  int get overdueCount => overdueTasks.length;

  int get completedCount => completedTasks.length;

  int get pendingCount => activeTasks.where((t) => !t.isCompleted).length;

  int get upcomingCount => upcomingTasks.length;

  static bool get isSyncing => false;

  static Future<void> fullSync() async {}
}
