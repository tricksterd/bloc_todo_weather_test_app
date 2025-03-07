import '../../core/error/custom_error.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasource/weather_data_source/lat_lng_data_source.dart';
import '../datasource/weather_data_source/remote_data_source.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final RemoteDataSource remoteDataSource;
  final LatLngDataSource latLngDataSource;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.latLngDataSource,
  });

  @override
  Future<Weather> getWeather() async {
    try {
      final position = await latLngDataSource.getCurrentPosition();

      final weather = await remoteDataSource.getWeather(position);

      return weather;
    } catch (e) {
      throw CustomError(
        errorMessage: e.toString(),
      );
    }
  }
}
