import '../entities/task.dart';
import '../../data/repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<Task>> call() {
    return repository.getTasks();
  }
}
