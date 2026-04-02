import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/forecast.dart';
import '../models/location.dart';
import '../models/weather.dart';

class OpenWeatherMapApi {
  OpenWeatherMapApi({
    required this.apiKey,
    this.units = 'metric',
    this.lang = 'fr',
  });

  static const String baseUrl = 'https://api.openweathermap.org';

  final String apiKey;
  final String units;
  final String lang;

  String getIconUrl(String icon) {
    return 'https://openweathermap.org/img/wn/$icon@4x.png';
  }

  Future<Iterable<Location>> searchLocations(
    String query, {
    int limit = 5,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/geo/1.0/direct?appid=$apiKey&q=$query&limit=$limit'),
    );

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body) as List;
      return json.map((item) => Location.fromJson(item as Map<String, dynamic>));
    }

    throw Exception(
        'Impossible de récupérer les données de localisation (HTTP ${response.statusCode})');
  }

  Future<Location?> reverseGeocode(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$baseUrl/geo/1.0/reverse?appid=$apiKey&lat=$lat&lon=$lon&limit=1'),
    );

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body) as List;
      if (json.isNotEmpty) {
        return Location.fromJson(json[0] as Map<String, dynamic>);
      }
    }

    return null;
  }

  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/data/2.5/weather?appid=$apiKey&lat=$lat&lon=$lon&units=$units&lang=$lang',
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Weather.fromJson(json);
    }

    throw Exception(
        'Impossible de récupérer les données météo (HTTP ${response.statusCode})');
  }

  Future<List<Forecast>> getForecast(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/data/2.5/forecast?appid=$apiKey&lat=$lat&lon=$lon&units=$units&lang=$lang',
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final list = json['list'] as List;
      return list.map((item) => Forecast.fromJson(item as Map<String, dynamic>)).toList();
    }

    throw Exception(
        'Impossible de récupérer la prévision météo (HTTP ${response.statusCode})');
  }
}
