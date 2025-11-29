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
      'date': date.toIso8601String(),
      'mileage': mileage,
      'liters': liters,
    };
  }

  static Operation fromMap(Map<String, dynamic> map) {
    return Operation(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      comment: map['comment'],
      date: DateTime.parse(map['date']),
      mileage: map['mileage'],
      liters: map['liters'],
    );
  }
}