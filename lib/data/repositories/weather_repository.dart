import '../services/weather_api_service.dart';
import '../../domain/models/weather_data.dart';

class WeatherRepository {
  final WeatherApiService _apiService = WeatherApiService();

  Future<WeatherData> getWeather(String city) async {
    try {
      return await _apiService.getWeatherByCity(city);
    } catch (e) {
      print('⚠️ Используем мок данные погоды из-за ошибки: $e');
      return _apiService.getMockWeather();
    }
  }

  Future<WeatherData> getCurrentLocationWeather() async {
    // Можно добавить геолокацию позже
    return await getWeather('Moscow');
  }
}