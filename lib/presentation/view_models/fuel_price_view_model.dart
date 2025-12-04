import 'package:flutter/foundation.dart';
import '../../data/repositories/fuel_price_repository.dart';
import '../../data/services/local_storage_service.dart';
import '../../domain/models/fuel_price.dart';

class FuelPriceViewModel with ChangeNotifier {
  final FuelPriceRepository _fuelRepository = FuelPriceRepository();
  final LocalStorageService _localStorage = LocalStorageService();

  List<FuelPrice> _fuelPrices = [];
  bool _isLoading = false;
  String _selectedFuelType = 'AI-95';

  List<FuelPrice> get fuelPrices => _fuelPrices;
  bool get isLoading => _isLoading;
  String get selectedFuelType => _selectedFuelType;

  FuelPriceViewModel() {
    _loadFuelPrices();
    _selectedFuelType = _localStorage.getFuelType();
  }

  Future<void> _loadFuelPrices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _fuelPrices = await _fuelRepository.getFuelPrices();
    } catch (e) {
      if (kDebugMode) {
        print('Ошибка загрузки цен на топливо: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshFuelPrices() async {
    await _loadFuelPrices();
  }

  void setSelectedFuelType(String type) {
    _selectedFuelType = type;
    _localStorage.saveFuelType(type);
    notifyListeners();
  }

  FuelPrice? getCurrentFuelPrice() {
    return _fuelPrices.firstWhere(
      (price) => price.type == _selectedFuelType,
      orElse: () => FuelPrice(
        type: _selectedFuelType,
        price: 48.90,
        currency: 'RUB',
        station: 'Средняя цена',
        lastUpdated: DateTime.now(),
      ),
    );
  }

  Future<double> calculateRefuelCost(double liters) async {
    final price = getCurrentFuelPrice();
    return price!.price * liters;
  }
}