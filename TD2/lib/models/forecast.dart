class Forecast {
  Forecast({
    required this.dateTime,
    required this.condition,
    required this.icon,
    required this.temperature,
  });

  final DateTime dateTime;
  final String condition;
  final String icon;
  final double temperature;

  Forecast.fromJson(Map<String, dynamic> json)
      : this(
          dateTime: DateTime.parse(json['dt_txt'] as String),
          condition: json['weather'][0]['main'] as String,
          icon: json['weather'][0]['icon'] as String,
          temperature: (json['main']['temp'] as num).toDouble(),
        );
}
