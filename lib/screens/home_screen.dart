import 'package:flutter/material.dart';
import 'add_record_screen.dart';
import 'stats_screen.dart';
import 'brands_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoHelper'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Краткая сводка
          _buildSummaryCard(),

          // Список последних операций
          _buildRecentOperations(),

          // Кнопки навигации
          _buildNavigationButtons(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecordScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Затраты за октябрь',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '12 450 ₽',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Средний расход: 8.2 л/100км',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOperations() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Последние операции',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  _OperationItem(
                    date: '25.10.2025',
                    type: 'Заправка',
                    amount: '3 500 ₽',
                    comment: 'АИ-95, 40л',
                  ),
                  _OperationItem(
                    date: '20.10.2025',
                    type: 'Сервис',
                    amount: '5 000 ₽',
                    comment: 'Замена масла',
                  ),
                  _OperationItem(
                    date: '15.10.2025',
                    type: 'Запчасть',
                    amount: '2 800 ₽',
                    comment: 'Тормозные колодки',
                  ),
                  _OperationItem(
                    date: '10.10.2025',
                    type: 'Мойка',
                    amount: '1 150 ₽',
                    comment: 'Полная мойка',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatsScreen()),
                );
              },
              icon: const Icon(Icons.show_chart),
              label: const Text('Статистика'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BrandsScreen()),
                );
              },
              icon: const Icon(Icons.directions_car),
              label: const Text('Бренды авто'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationItem extends StatelessWidget {
  final String date;
  final String type;
  final String amount;
  final String comment;

  const _OperationItem({
    required this.date,
    required this.type,
    required this.amount,
    required this.comment,
  });

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Заправка':
        return Colors.green;
      case 'Сервис':
        return Colors.orange;
      case 'Запчасть':
        return Colors.red;
      case 'Мойка':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getTypeColor(type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTypeIcon(type),
            color: _getTypeColor(type),
            size: 20,
          ),
        ),
        title: Text(
          type,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$date • $comment'),
        trailing: Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Заправка':
        return Icons.local_gas_station;
      case 'Сервис':
        return Icons.build;
      case 'Запчасть':
        return Icons.settings;
      case 'Мойка':
        return Icons.local_car_wash;
      default:
        return Icons.receipt;
    }
  }
}