import 'package:hive/hive.dart';

import '../../domain/entities/task.dart';
import 'task_repository.dart';

class HiveTaskRepository implements TaskRepository {
  final Box<Task> _box = Hive.box<Task>('tasks');

  HiveTaskRepository();

  @override
  Future<List<Task>> getTasks() async {
    return _box.values.toList();
  }

  @override
  Future<void> addTask(Task task) async {
    await _box.put(task.id, task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }
}
