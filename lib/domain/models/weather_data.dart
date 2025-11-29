class WeatherData {
  final String city;
  final double temperature;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;
  final String condition;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];

    return WeatherData(
      city: json['name'] ?? 'Неизвестно',
      temperature: (main['temp'] ?? 0.0).toDouble(),
      description: weather['description'] ?? 'Нет данных',
      icon: weather['icon'] ?? '01d',
      humidity: (main['humidity'] ?? 0.0).toDouble(),
      windSpeed: (wind['speed'] ?? 0.0).toDouble(),
      condition: weather['main'] ?? 'Clear',
    );
  }

  // Метод для получения URL иконки погоды
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  // Метод для получения рекомендации по вождению
  String get drivingRecommendation {
    switch (condition.toLowerCase()) {
      case 'rain':
        return 'Дождь. Будьте осторожны, увеличьте дистанцию';
      case 'snow':
        return 'Снег. Используйте зимнюю резину, снизьте скорость';
      case 'fog':
        return 'Туман. Включите противотуманные фары';
      case 'thunderstorm':
        return 'Гроза. Рекомендуется отложить поездку';
      case 'extreme':
        return 'Экстремальная погода. Не рекомендуется выезжать';
      default:
        return 'Хорошая погода для поездки';
    }
  }
}