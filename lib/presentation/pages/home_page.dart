import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/constants.dart';
import '../bloc/task/task_bloc.dart';
import '../bloc/weather/weather_bloc.dart';
import '../widgets/editing_form_task_alert_dialog.dart';
import '../widgets/tasks_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    void callback(Filter filter) {
      context.read<TasksBloc>().add(FilterTasksEvent(filter: filter));
    }

    return Scaffold(
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state.status == TaskStatus.initial ||
              state.status == TaskStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == TaskStatus.error) {
            return Center(
              child: Text(state.error.errorMessage),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Stack(
              children: [
                Positioned(
                    right: 10,
                    top: 10,
                    child: BlocBuilder<WeatherBloc, WeatherState>(
                      builder: (context, state) {
                        return state.status == WeatherStatus.loaded
                            ? AnimatedOpacity(
                                opacity: state.status == WeatherStatus.loaded
                                    ? 1.0
                                    : 0.0,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeIn,
                                child: Column(
                                  children: [
                                    showIcon(state.weather.icon),
                                    Row(
                                      children: [
                                        Text(state.weather.description),
                                        Text(
                                            '${state.weather.temp.toStringAsFixed(2)} ℃')
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox();
                      },
                    )),

                // SizedBox(height: 30,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 50,
                        child: DropdownButton(
                          items: ['All', ...kCategories].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: state.selectedCategory,
                          onChanged: (String? value) {
                            context.read<TasksBloc>().add(
                                  FilterTasksEvent(
                                    category: value,
                                  ),
                                );
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        filterButton(
                            filter: Filter.all,
                            selectedFilter: state.selectedFilter,
                            callback: () {
                              callback(Filter.all);
                            }),
                        filterButton(
                            filter: Filter.active,
                            selectedFilter: state.selectedFilter,
                            callback: () {
                              callback(Filter.active);
                            }),
                        filterButton(
                            filter: Filter.completed,
                            selectedFilter: state.selectedFilter,
                            callback: () {
                              callback(Filter.completed);
                            }),
                      ],
                    ),
                    Expanded(child: TasksList(tasks: state.tasks)),
                  ],
                ),
              ],
            ),
          );
          // if
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => EditingFormTaskAlertDialog(
              callback: ({
                required String title,
                required String desc,
                required String category,
              }) {
                context.read<TasksBloc>().add(AddTaskEvent(
                      title: title,
                      desc: desc,
                      category: category,
                    ));
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget filterButton({
  required Filter filter,
  required Filter selectedFilter,
  required Function() callback,
}) {
  return TextButton(
      onPressed: () {
        callback();
      },
      child: Text(
        filter == Filter.all
            ? 'All'
            : filter == Filter.active
                ? 'Active'
                : 'Completed',
        style: TextStyle(
            fontSize: 18,
            color: selectedFilter == filter ? Colors.blue : Colors.grey),
      ));
}

Widget showIcon(String icon) {
  print('http://$kIconHost/img/wn/$icon@4x.png');
  return Image.network(
    'http://$kIconHost/img/wn/$icon@4x.png',
    width: 70,
    height: 70,
  );
}

Widget formatText(String description) {
  final formattedString = description;
  return Text(
    formattedString,
    style: const TextStyle(
      fontSize: 24.0,
    ),
    textAlign: TextAlign.center,
  );
}
