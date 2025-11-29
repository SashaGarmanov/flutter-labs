import 'package:flutter/material.dart';
import '../models/operation.dart';

class StatsScreen extends StatefulWidget {
  final List<Operation> operations;

  const StatsScreen({super.key, required this.operations});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _calculateTotal() {
    return widget.operations.fold(0, (sum, operation) => sum + operation.amount);
  }

  double _calculateFuelConsumption() {
    final fuelOperations = widget.operations
        .where((op) => op.type == 'Заправка' && op.liters != null && op.mileage != null)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (fuelOperations.length < 2) return 0.0;

    double totalConsumption = 0;
    int calculations = 0;

    for (int i = 1; i < fuelOperations.length; i++) {
      final current = fuelOperations[i];
      final previous = fuelOperations[i - 1];

      final distance = current.mileage! - previous.mileage!;
      final fuel = current.liters!;

      if (distance > 0 && fuel > 0) {
        final consumption = (fuel / distance) * 100;
        totalConsumption += consumption;
        calculations++;
      }
    }

    return calculations > 0 ? totalConsumption / calculations : 0.0;
  }

  Map<String, int> _calculateCategoryTotals() {
    final Map<String, int> totals = {};
    for (var operation in widget.operations) {
      totals[operation.type] = (totals[operation.type] ?? 0) + operation.amount;
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();
    final categoryTotals = _calculateCategoryTotals();
    final fuelConsumption = _calculateFuelConsumption();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalStats(total),
            const SizedBox(height: 24),
            _buildFuelConsumption(fuelConsumption),
            const SizedBox(height: 24),
            _buildCategoryExpenses(categoryTotals, total),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalStats(int total) {
    final currentMonth = DateTime.now().month;
    final monthlyTotal = widget.operations
        .where((op) => op.date.month == currentMonth)
        .fold(0, (sum, op) => sum + op.amount);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Общие затраты',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$total ₽',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('За месяц', '$monthlyTotal ₽'),
                _buildStatItem('Всего операций', '${widget.operations.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFuelConsumption(double consumption) {
    final fuelOperations = widget.operations.where((op) => op.type == 'Заправка').length;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Расход топлива',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        consumption > 0 ? consumption.toStringAsFixed(1) : '--',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        'л/100км',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '$fuelOperations',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                      Text(
                        'заправок',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (consumption > 0) ...[
              LinearProgressIndicator(
                value: consumption / 15,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
              ),
              const SizedBox(height: 8),
              Text(
                'На ${((15 - consumption) / 15 * 100).toStringAsFixed(0)}% экономичнее максимума',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ] else if (fuelOperations < 2) ...[
              Text(
                'Нужно больше данных для расчета',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryExpenses(Map<String, int> categoryTotals, int total) {
    final categories = [
      {'name': 'Заправка', 'color': Colors.green},
      {'name': 'Сервис', 'color': Colors.orange},
      {'name': 'Запчасти', 'color': Colors.red},
      {'name': 'Мойка', 'color': Colors.blue},
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Расходы по категориям',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: categories.map((category) {
                final amount = categoryTotals[category['name']] ?? 0;
                final percentage = total > 0 ? (amount / total * 100) : 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: category['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(category['name'] as String),
                      ),
                      Text('$amount ₽'),
                      const SizedBox(width: 8),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}