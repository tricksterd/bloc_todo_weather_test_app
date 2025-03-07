import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();

  Future<void> addTask(Task newTask);

  Future<void> updateTask(Task updatedTask);

  Future<void> deleteTask(Task taskToDelete);
}
