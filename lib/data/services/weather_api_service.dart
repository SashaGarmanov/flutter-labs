import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/weather_data.dart';

class WeatherApiService {
  // Бесплатный API ключ OpenWeatherMap (демо)
  static const String _apiKey = 'bd5e378503939ddaee76f12ad7a97608'; // Демо ключ
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherData> getWeatherByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric&lang=ru'),
      );

      print('🌤️ Статус ответа OpenWeatherMap: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✅ Погода загружена для города: ${data['name']}');
        return WeatherData.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Неверный API ключ OpenWeatherMap');
      } else if (response.statusCode == 404) {
        throw Exception('Город "$city" не найден');
      } else {
        print('❌ Ошибка OpenWeatherMap: ${response.statusCode}');
        throw Exception('Ошибка загрузки погоды: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Ошибка получения погоды: $e');
      rethrow;
    }
  }

  // Получение погоды по текущей геолокации (можно добавить позже)
  Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=ru'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Ошибка загрузки погоды по местоположению');
      }
    } catch (e) {
      print('❌ Ошибка получения погоды по геолокации: $e');
      rethrow;
    }
  }

  // Мок данные на случай ошибки API
  WeatherData getMockWeather() {
    return WeatherData(
      city: 'Москва',
      temperature: 15.5,
      description: 'облачно с прояснениями',
      icon: '04d',
      humidity: 65.0,
      windSpeed: 3.2,
      condition: 'Clouds',
    );
  }
}