import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Сохранение последнего пробега
  Future<void> saveLastMileage(int mileage) async {
    await _prefs?.setInt('last_mileage', mileage);
  }

  int getLastMileage() {
    return _prefs?.getInt('last_mileage') ?? 0;
  }

  // Сохранение предпочтительного типа топлива
  Future<void> saveFuelType(String fuelType) async {
    await _prefs?.setString('fuel_type', fuelType);
  }

  String getFuelType() {
    return _prefs?.getString('fuel_type') ?? 'AI-95';
  }

  // Сохранение настроек валюты
  Future<void> saveCurrency(String currency) async {
    await _prefs?.setString('currency', currency);
  }

  String getCurrency() {
    return _prefs?.getString('currency') ?? 'RUB';
  }

  // Очистка всех данных
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}