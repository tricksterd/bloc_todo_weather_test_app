import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/error/custom_error.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/usecases/task_usecases/task_usecases.dart';

part 'task_event.dart';
part 'task_state.dart';

const uuid = Uuid();

typedef _BodyFunction = Future<void> Function();

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  List<Task> _allTasks = [];

  TasksBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TasksState.initial()) {
    on<LoadTasksEvent>(_loadTasks);

    on<AddTaskEvent>(_addTask);

    on<UpdateTaskEvent>(_updateTask);

    on<DeleteTaskEvent>(_deleteTask);

    add(LoadTasksEvent());

    on<FilterTasksEvent>(_filterTask);
  }

  void _loadTasks(
    LoadTasksEvent event,
    Emitter<TasksState> emit,
  ) async {
    await _performEvent(
        bodyFunction: () async {
          emit(state.copyWith(status: TaskStatus.loading));

          final tasks = await getTasks();

          _allTasks = tasks;

          final newState = state.copyWith(
            tasks: tasks,
            status: TaskStatus.loaded,
          );

          emit(newState);
        },
        emit: emit);
  }

  void _addTask(
    AddTaskEvent event,
    Emitter<TasksState> emit,
  ) async {
    await _performEvent(
        bodyFunction: () async {
          final newTask = Task(
            id: uuid.v4(),
            title: event.title,
            description: event.desc,
            isCompleted: false,
            category: event.category,
          );

          await addTask(newTask);

          _allTasks.add(newTask);

          final newState = state.copyWith(
            tasks: [...state.tasks, newTask],
          );

          emit(newState);
        },
        emit: emit);
  }

  void _updateTask(UpdateTaskEvent event, Emitter<TasksState> emit) async {
    await _performEvent(
        bodyFunction: () async {
          await updateTask(event.task);

          final newTasks = _allTasks.map((task) {
            if (task.id == event.task.id) {
              return event.task;
            }
            return task;
          }).toList();

          _allTasks = newTasks;

          final newState = state.copyWith(
            tasks: newTasks,
          );

          emit(newState);
        },
        emit: emit);
  }

  void _deleteTask(
    DeleteTaskEvent event,
    Emitter<TasksState> emit,
  ) async {
    await _performEvent(
        bodyFunction: () async {
          await deleteTask(event.task);

          final newTasks =
              state.tasks.where((task) => task.id != event.task.id).toList();

          _allTasks = newTasks;

          final newState = state.copyWith(
            tasks: newTasks,
          );

          emit(newState);
        },
        emit: emit);
  }

  void _filterTask(FilterTasksEvent event, Emitter<TasksState> emit) async {
    List<Task> filteredTask = List.from(_allTasks);

    final filter = event.filter ?? state.selectedFilter;
    final category = event.category ?? state.selectedCategory;

    switch (filter) {
      case Filter.active:
        filteredTask = filteredTask.where((task) => !task.isCompleted).toList();
        break;
      case Filter.completed:
        filteredTask = filteredTask.where((task) => task.isCompleted).toList();
        break;
      case Filter.all:
      default:
        filteredTask = List.from(_allTasks);
        break;
    }

    if (category != 'All') {
      filteredTask =
          filteredTask.where((task) => task.category == category).toList();
    }

    final newState = state.copyWith(
      tasks: filteredTask,
      selectedFilter: filter,
      selectedCategory: category,
    );

    emit(newState);
  }

  void toggleTask(Task task) {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);

    add(UpdateTaskEvent(updatedTask));
    add(FilterTasksEvent());
  }

  Future<void> _performEvent(
      {required _BodyFunction bodyFunction, required emit}) async {
    try {
      await bodyFunction();
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: TaskStatus.error,
        error: e,
      ));
    }
  }
}
