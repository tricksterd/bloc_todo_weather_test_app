import '../../models/task_model.dart';

abstract class TaskDataSource {
  Future<List<TaskModel>> getTasks();

  Future<void> addTask(TaskModel task);

  Future<void> deleteTask(String taskId);

  Future<void> updateTask(TaskModel task);
}
