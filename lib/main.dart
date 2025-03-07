import 'data/datasource/weather_data_source/lat_lng_data_source.dart';
import 'data/datasource/weather_data_source/remote_data_source.dart';
import 'data/repositories/weather_repository_impl.dart';
import 'domain/usecases/weather/get_weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'data/datasource/tasks_data_source/hive_task_data_source.dart';
import 'data/models/task_model.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/usecases/task_usecases/add_task.dart';
import 'domain/usecases/task_usecases/delete_task.dart';
import 'domain/usecases/task_usecases/get_tasks.dart';
import 'domain/usecases/task_usecases/update_task.dart';
import 'presentation/bloc/task/task_bloc.dart';
import 'presentation/bloc/weather/weather_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TaskModelAdapter());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => TaskRepositoryImpl(
            HiveTaskDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => WeatherRepositoryImpl(
            remoteDataSource: RemoteDataSourceImpl(
              http.Client(),
            ),
            latLngDataSource: LatLngDataSourceImpl(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TasksBloc>(
            create: (context) => TasksBloc(
              addTask: AddTask(
                context.read<TaskRepositoryImpl>(),
              ),
              deleteTask: DeleteTask(
                context.read<TaskRepositoryImpl>(),
              ),
              getTasks: GetTasks(
                context.read<TaskRepositoryImpl>(),
              ),
              updateTask: UpdateTask(
                context.read<TaskRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(
              getWeather: GetWeather(
                context.read<WeatherRepositoryImpl>(),
              ),
            ),
          )
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ),
      ),
    );
  }
}
