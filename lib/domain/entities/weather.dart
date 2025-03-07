import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String description;
  final String icon;
  final double temp;
  const Weather({
    required this.description,
    required this.icon,
    required this.temp,
  });

  factory Weather.initial() => const Weather(
        description: '',
        icon: '',
        temp: 100.0,
      );

  @override
  List<Object> get props => [description, icon, temp];
}
