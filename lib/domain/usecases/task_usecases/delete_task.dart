import '../../entities/task.dart';
import '../../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(Task taskToDelete) async {
    repository.deleteTask(taskToDelete);
  }
}
