import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../../../core/constants/constants.dart';
import '../../models/weather_model.dart';

abstract class RemoteDataSource {
  Future<WeatherModel> getWeather(LocationData position);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client httpClient;
  RemoteDataSourceImpl(this.httpClient);

  @override
  Future<WeatherModel> getWeather(LocationData position) async {
    final Uri uri = Uri(
        scheme: 'https',
        host: kApiHost,
        path: '/data/2.5/weather',
        queryParameters: {
          'lat': position.latitude.toString(),
          'lon': position.longitude.toString(),
          'units': kUnit,
          'appid': dotenv.env['APPID']
        });
    try {
      final http.Response response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
            'Request failed\nStatus Code: ${response.statusCode}\nReason: ${response.reasonPhrase}');
      }

      final responseBody = json.decode(response.body);

      final WeatherModel weather = WeatherModel.fromJson(responseBody);

      return weather;
    } catch (e) {
      rethrow;
    }
  }
}
