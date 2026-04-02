import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/forecast.dart';
import '../models/weather.dart';
import '../services/openweathermap_api.dart';
import '../widgets/custom_scrollbar.dart';
import 'search_page.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    super.key,
  });

  final String locationName;
  final double latitude;
  final double longitude;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<_WeatherData> _weatherDataFuture;
  final ScrollController _horizontalScrollController = ScrollController();
  final DateFormat _dateFormatter = DateFormat.MMMMEEEEd();

  @override
  void initState() {
    super.initState();
    final openWeatherMapApi = context.read<OpenWeatherMapApi>();
    _weatherDataFuture = _loadWeatherData(openWeatherMapApi);
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  Future<_WeatherData> _loadWeatherData(OpenWeatherMapApi api) async {
    final weather = await api.getWeather(widget.latitude, widget.longitude);
    final forecast = await api.getForecast(widget.latitude, widget.longitude);
    
    // Pour la position actuelle, essayer d'obtenir le nom de la ville via reverse geocoding
    String locationName = widget.locationName;
    if (widget.locationName == 'Position actuelle') {
      final location = await api.reverseGeocode(widget.latitude, widget.longitude);
      if (location != null) {
        locationName = location.name;
      }
    }
    
    return _WeatherData(
      weather: weather,
      forecast: forecast,
      locationName: locationName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<_WeatherData>(
          future: _weatherDataFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.locationName);
            }
            return Text(widget.locationName);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const SearchPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<_WeatherData>(
        future: _weatherDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Une erreur est survenue.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Aucune donnée disponible.'),
            );
          }

          final openWeatherMapApi = context.read<OpenWeatherMapApi>();
          final data = snapshot.data!;
          final weather = data.weather;
          final forecast = data.forecast;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Image.network(
                    openWeatherMapApi.getIconUrl(weather.icon),
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weather.condition,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weather.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Informations supplémentaires
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[900],
                    ),
                    child: Column(
                      children: [
                        _buildWeatherInfoRow(
                          'Ressenti',
                          '${weather.feelsLike.toStringAsFixed(1)}°C',
                        ),
                        _buildWeatherInfoRow(
                          'Humidité',
                          '${weather.humidity}%',
                        ),
                        _buildWeatherInfoRow(
                          'Pression',
                          '${weather.pressure} hPa',
                        ),
                        _buildWeatherInfoRow(
                          'Vitesse du vent',
                          '${weather.windSpeed.toStringAsFixed(1)} m/s',
                        ),
                        _buildWeatherInfoRow(
                          'Nébulosité',
                          '${weather.cloudiness}%',
                        ),
                        _buildWeatherInfoRow(
                          'Température min',
                          '${weather.tempMin.toStringAsFixed(1)}°C',
                        ),
                        _buildWeatherInfoRow(
                          'Température max',
                          '${weather.tempMax.toStringAsFixed(1)}°C',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Prévision 5 jours
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Prévision des 5 jours',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (forecast.isNotEmpty)
                    CustomScrollbarWithSingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _buildForecastCards(
                          forecast,
                          openWeatherMapApi,
                        ),
                      ),
                    )
                  else
                    const Text('Aucune prévision disponible.'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeatherInfoRow(
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Divider(),
          ),
      ],
    );
  }

  List<Widget> _buildForecastCards(
    List<Forecast> forecast,
    OpenWeatherMapApi api,
  ) {
    // Grouper les prévisions par jour et prendre une prévision par jour (à midi)
    final Map<String, Forecast> dailyForecasts = {};
    
    for (final f in forecast) {
      final dayKey = _dateFormatter.format(f.dateTime);
      if (!dailyForecasts.containsKey(dayKey) || f.dateTime.hour == 12) {
        dailyForecasts[dayKey] = f;
      }
    }

    return dailyForecasts.values
        .take(5)
        .map((forecast) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[900],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat.E('fr_FR').format(forecast.dateTime),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Image.network(
                  api.getIconUrl(forecast.icon),
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 8),
                Text(
                  '${forecast.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        })
        .toList();
  }
}

class _WeatherData {
  _WeatherData({
    required this.weather,
    required this.forecast,
    required this.locationName,
  });

  final Weather weather;
  final List<Forecast> forecast;
  final String locationName;
}

