class Weather {
  Weather({
    required this.condition,
    required this.description,
    required this.icon,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.cloudiness,
  });

  final String condition;
  final String description;
  final String icon;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int cloudiness;

  Weather.fromJson(Map<String, dynamic> json)
      : this(
          condition: json['weather'][0]['main'] as String,
          description: json['weather'][0]['description'] as String,
          icon: json['weather'][0]['icon'] as String,
          temperature: (json['main']['temp'] as num).toDouble(),
          feelsLike: (json['main']['feels_like'] as num).toDouble(),
          tempMin: (json['main']['temp_min'] as num).toDouble(),
          tempMax: (json['main']['temp_max'] as num).toDouble(),
          pressure: json['main']['pressure'] as int,
          humidity: json['main']['humidity'] as int,
          windSpeed: (json['wind']['speed'] as num).toDouble(),
          cloudiness: json['clouds']['all'] as int,
        );
}
