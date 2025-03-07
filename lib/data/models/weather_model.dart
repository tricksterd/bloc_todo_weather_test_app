import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.icon,
    required super.description,
    required super.temp,
  });
  

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];

    return WeatherModel(
      description: weather['description'],
      icon: weather['icon'],
      temp: main['temp'],
    );
  }
}
