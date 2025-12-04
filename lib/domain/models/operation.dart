class Operation {
  final String id;
  final String type;
  final int amount;
  final String comment;
  final DateTime date;
  final int? mileage;
  final double? liters;

  Operation({
    required this.id,
    required this.type,
    required this.amount,
    required this.comment,
    required this.date,
    this.mileage,
    this.liters,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'comment': comment,
      'date': date.toIso8601String(), // Важно: используем ISO строку
      'mileage': mileage,
      'liters': liters,
    };
  }

  static Operation fromMap(Map<String, dynamic> map) {
    return Operation(
      id: map['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: map['type']?.toString() ?? 'Неизвестно',
      amount: (map['amount'] is int) ? map['amount'] : int.tryParse(map['amount']?.toString() ?? '0') ?? 0,
      comment: map['comment']?.toString() ?? '',
      date: DateTime.parse(map['date']?.toString() ?? DateTime.now().toIso8601String()),
      mileage: (map['mileage'] is int) ? map['mileage'] : int.tryParse(map['mileage']?.toString() ?? ''),
      liters: (map['liters'] is double) ? map['liters'] : double.tryParse(map['liters']?.toString() ?? ''),
    );
  }
}