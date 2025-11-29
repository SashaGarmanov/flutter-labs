import '../services/fuel_api_service.dart';
import '../../domain/models/fuel_price.dart';

class FuelPriceRepository {
  final FuelApiService _apiService = FuelApiService();

  Future<List<FuelPrice>> getFuelPrices() async {
    return await _apiService.getFuelPrices();
  }

  Future<FuelPrice> getFuelPriceByType(String type) async {
    return await _apiService.getFuelPriceByType(type);
  }

  Future<double> calculateRefuelCost(String type, double liters) async {
    final price = await getFuelPriceByType(type);
    return price.price * liters;
  }
}