part of 'task_bloc.dart';

enum TaskStatus {
  initial,
  loading,
  loaded,
  error,
}

enum Filter {
  all,
  active,
  completed,
}

class TasksState extends Equatable {
  final TaskStatus status;
  final List<Task> tasks;
  final Filter selectedFilter;
  final String selectedCategory;
  final CustomError error;

  const TasksState({
    required this.status,
    required this.tasks,
    required this.selectedFilter,
    required this.selectedCategory,
    required this.error,
  });

  factory TasksState.initial() {
    return const TasksState(
      status: TaskStatus.initial,
      tasks: [],
      selectedFilter: Filter.all,
      selectedCategory: 'All',
      error: CustomError(),
    );
  }

  @override
  String toString() {
    return 'TasksState(status: $status, tasks: $tasks, selectedFilter: $selectedFilter, selectedCategory: $selectedCategory, error: $error)';
  }

  @override
  List<Object> get props {
    return [
      status,
      tasks,
      selectedFilter,
      selectedCategory,
      error,
    ];
  }

  TasksState copyWith({
    TaskStatus? status,
    List<Task>? tasks,
    Filter? selectedFilter,
    String? selectedCategory,
    CustomError? error,
  }) {
    return TasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error ?? this.error,
    );
  }
}
