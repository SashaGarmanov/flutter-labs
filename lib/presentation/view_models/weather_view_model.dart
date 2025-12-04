import 'package:flutter/foundation.dart';
import '../../data/repositories/weather_repository.dart';
import '../../domain/models/weather_data.dart';

class WeatherViewModel with ChangeNotifier {
  final WeatherRepository _weatherRepository = WeatherRepository();

  WeatherData? _weather;
  bool _isLoading = false;
  String _error = '';
  String _selectedCity = 'Moscow';

  WeatherData? get weather => _weather;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedCity => _selectedCity;

  WeatherViewModel() {
    loadWeather();
  }

  Future<void> loadWeather() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _weather = await _weatherRepository.getWeather(_selectedCity);
      print('✅ Погода загружена: ${_weather?.city}, ${_weather?.temperature}°C');
    } catch (e) {
      _error = 'Ошибка загрузки погоды: $e';
      print('❌ $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshWeather() async {
    await loadWeather();
  }

  Future<void> setCity(String city) async {
    _selectedCity = city;
    await loadWeather();
  }

  // Список популярных городов для выбора
  final List<String> availableCities = [
    'Moscow',
    'Saint Petersburg',
    'Novosibirsk',
    'Yekaterinburg',
    'Kazan',
    'Nizhny Novgorod',
    'Chelyabinsk',
    'Samara',
    'Omsk',
    'Rostov-on-Don',
  ];
}