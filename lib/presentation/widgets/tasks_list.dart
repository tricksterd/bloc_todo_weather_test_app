import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../bloc/task/task_bloc.dart';
import 'editing_form_task_alert_dialog.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (_) {
                  context.read<TasksBloc>().toggleTask(task);
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditingFormTaskAlertDialog(
                          task: task,
                          callback: ({
                            required String title,
                            required String desc,
                            required String category,
                          }) {
                            final newTask = task.copyWith(
                              title: title,
                              description: desc,
                              category: category,
                            );
                            context
                                .read<TasksBloc>()
                                .add(UpdateTaskEvent(newTask));
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<TasksBloc>().add(DeleteTaskEvent(task));
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              title: Text(task.title),
              subtitle: Text(task.description),
            ),
          );
        });
  }
}
