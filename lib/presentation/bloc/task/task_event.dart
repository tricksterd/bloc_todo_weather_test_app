part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

abstract class TasksEvent {}

class LoadTasksEvent extends TasksEvent {}

class AddTaskEvent extends TasksEvent {
  final String title;
  final String desc;
  final String category;
  AddTaskEvent({
    required this.title,
    required this.desc,
    required this.category,
  });
}

class UpdateTaskEvent extends TasksEvent {
  final Task task;
  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TasksEvent {
  final Task task;
  DeleteTaskEvent(this.task);
}

class FilterTasksEvent extends TasksEvent {
  final Filter? filter;
  final String? category;
  FilterTasksEvent({
    this.filter,
    this.category,
  });
}
