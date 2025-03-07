import '../../entities/weather.dart';
import '../../repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  Future<Weather> call() async {
    return await repository.getWeather();
  }
}
