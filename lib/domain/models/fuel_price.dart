class FuelPrice {
  final String type;
  final double price;
  final String currency;
  final String station;
  final DateTime lastUpdated;

  FuelPrice({
    required this.type,
    required this.price,
    required this.currency,
    required this.station,
    required this.lastUpdated,
  });

  factory FuelPrice.fromJson(Map<String, dynamic> json) {
    return FuelPrice(
      type: json['type'] ?? 'AI-95',
      price: (json['price'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'RUB',
      station: json['station'] ?? 'Заправка',
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'price': price,
      'currency': currency,
      'station': station,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}