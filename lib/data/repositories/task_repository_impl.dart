import '../../core/error/custom_error.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasource/tasks_data_source/task_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl extends TaskRepository {
  final TaskDataSource localDataSource;
  TaskRepositoryImpl(
    this.localDataSource,
  );

  @override
  Future<List<Task>> getTasks() async {
    try {
      final taskModels = await localDataSource.getTasks();

      final models = taskModels.map((model) => _toEntity(model)).toList();

      return models;
    } catch (e) {
      throw CustomError(
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> addTask(Task newTask) async {
    try {
      final newTaskModel = _toModel(newTask);

      await localDataSource.addTask(newTaskModel);
    } catch (e) {
      throw CustomError(
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> updateTask(Task updatedTask) async {
    try {
      final updatedTaskModel = _toModel(updatedTask);

      await localDataSource.updateTask(updatedTaskModel);
    } catch (e) {
      throw CustomError(
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> deleteTask(Task taskToDelete) async {
    try {
      await localDataSource.deleteTask(taskToDelete.id);
    } catch (e) {
      throw CustomError(
        errorMessage: e.toString(),
      );
    }
  }

  Task _toEntity(TaskModel taskModel) {
    return Task(
      id: taskModel.id,
      category: taskModel.category,
      title: taskModel.title,
      description: taskModel.description,
      isCompleted: taskModel.isCompleted,
    );
  }

  TaskModel _toModel(Task task) {
    return TaskModel(
      id: task.id,
      category: task.category,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
    );
  }
}
