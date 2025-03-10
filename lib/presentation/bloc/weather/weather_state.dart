part of 'weather_bloc.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error,
}

class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather weather;
  final CustomError error;
  const WeatherState({
    required this.status,
    required this.weather,
    required this.error,
  });

  factory WeatherState.initial() {
    return WeatherState(
      status: WeatherStatus.loading,
      weather: Weather.initial(),
      error: const CustomError(),
    );
  }

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    CustomError? error,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, weather, error];

  @override
  String toString() =>
      'WeatherState(weatherStatus: $status, weather: $weather, error: $error)';
}
