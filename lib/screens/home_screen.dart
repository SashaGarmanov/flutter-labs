import 'package:flutter/material.dart';
import 'add_record_screen.dart';
import 'stats_screen.dart';
import 'brands_screen.dart';
import '../models/operation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Operation> _operations = [
    Operation(
      id: '1',
      type: 'Заправка',
      amount: 3500,
      comment: 'АИ-95, 40л',
      date: DateTime(2023, 10, 25),
      mileage: 150000,
      liters: 40,
    ),
    Operation(
      id: '2',
      type: 'Сервис',
      amount: 5000,
      comment: 'Замена масла',
      date: DateTime(2023, 10, 20),
      mileage: 149800,
    ),
    Operation(
      id: '3',
      type: 'Запчасть',
      amount: 2800,
      comment: 'Тормозные колодки',
      date: DateTime(2023, 10, 15),
      mileage: 149500,
    ),
    Operation(
      id: '4',
      type: 'Мойка',
      amount: 1150,
      comment: 'Полная мойка',
      date: DateTime(2023, 10, 10),
      mileage: 149200,
    ),
  ];

  void _addOperation(Operation operation) {
    setState(() {
      _operations.insert(0, operation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoHelper'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _buildCurrentScreen(),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecordScreen(),
            ),
          );
          if (result != null) {
            _addOperation(result);
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Статистика',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Бренды',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return StatsScreen(operations: _operations);
      case 2:
        return const BrandsScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildSummaryCard(),
        _buildRecentOperations(),
      ],
    );
  }

  int _calculateTotal() {
    return _operations.fold(0, (sum, operation) => sum + operation.amount);
  }

  Widget _buildSummaryCard() {
    final total = _calculateTotal();

    return Card(
      margin: const EdgeInsets.all(16),
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Операций: ${_operations.length}',
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
              child: ListView.builder(
                itemCount: _operations.length,
                itemBuilder: (context, index) {
                  final operation = _operations[index];
                  return _OperationItem(
                    date: '${operation.date.day}.${operation.date.month}.${operation.date.year}',
                    type: operation.type,
                    amount: '${operation.amount} ₽',
                    comment: operation.comment,
                  );
                },
              ),
            ),
          ],
        ),
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