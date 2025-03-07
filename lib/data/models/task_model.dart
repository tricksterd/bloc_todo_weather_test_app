import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final String category;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.category,
  });
}
