import 'package:hive/hive.dart';

import '../../models/task_model.dart';
import 'task_data_source.dart';

class HiveTaskDataSource implements TaskDataSource {
  static const String boxName = 'tasksBox';

  Future<Box<TaskModel>> _openBox() async {
    return await Hive.openBox<TaskModel>(boxName);
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final box = await _openBox();
      return box.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addTask(TaskModel task) async {
    try {
      final box = await _openBox();
      await box.put(task.id, task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final box = await _openBox();
      await box.delete(taskId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      final box = await _openBox();
      await box.put(task.id, task);
    } catch (e) {
      rethrow;
    }
  }
}
