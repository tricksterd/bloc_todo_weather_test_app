import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/custom_error.dart';
import '../../../domain/entities/weather.dart';
import '../../../domain/usecases/weather/get_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;

  WeatherBloc({
    required this.getWeather,
  }) : super(WeatherState.initial()) {
    on<GetWeatherEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: WeatherStatus.loading));

        final weather = await getWeather();

        final newState =
            state.copyWith(status: WeatherStatus.loaded, weather: weather);

        emit(newState);
      } on CustomError catch (e) {
        emit(state.copyWith(
          status: WeatherStatus.error,
          error: e,
        ));
      }
    });

    add(GetWeatherEvent());
  }
}
