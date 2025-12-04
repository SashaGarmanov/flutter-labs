import '../../domain/models/fuel_price.dart';

class FuelApiService {
  Future<List<FuelPrice>> getFuelPrices() async {
    // Простые мок данные без API
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      FuelPrice(
        type: 'AI-92',
        price: 45.20,
        currency: 'RUB',
        station: 'Лукойл',
        lastUpdated: DateTime.now(),
      ),
      FuelPrice(
        type: 'AI-95',
        price: 48.90,
        currency: 'RUB',
        station: 'Роснефть',
        lastUpdated: DateTime.now(),
      ),
      FuelPrice(
        type: 'Дизель',
        price: 50.10,
        currency: 'RUB',
        station: 'Газпромнефть',
        lastUpdated: DateTime.now(),
      ),
    ];
  }

  Future<FuelPrice> getFuelPriceByType(String type) async {
    final prices = await getFuelPrices();
    return prices.firstWhere(
      (price) => price.type == type,
      orElse: () => FuelPrice(
        type: type,
        price: 48.90,
        currency: 'RUB',
        station: 'Средняя цена',
        lastUpdated: DateTime.now(),
      ),
    );
  }
}