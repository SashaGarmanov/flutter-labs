import 'package:flutter/material.dart';
import 'add_record_screen.dart';
import 'stats_screen.dart';
import 'brands_screen.dart';
import '../../domain/models/operation.dart';
import '../view_models/weather_view_model.dart';
import '../view_models/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final HomeViewModel _viewModel = HomeViewModel();
  final WeatherViewModel _weatherViewModel = WeatherViewModel();
  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  void _addOperation(Operation operation) async {
    try {
      await _viewModel.addOperation(operation);
      // Данные автоматически обновятся через слушатель
    } catch (e) {
      // Покажем ошибку пользователю
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка сохранения: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_viewModel.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              _viewModel.debugStorage();
            },
            tooltip: 'Отладка хранилища',
          ),
        ],
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

  Widget _buildAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return const Text('AutoHelper');
      case 1:
        return const Text('Статистика');
      case 2:
        return const Text('Бренды авто');
      default:
        return const Text('AutoHelper');
    }
  }

  Widget _buildCurrentScreen() {
    if (_viewModel.isLoading && _viewModel.operations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return StatsScreen(operations: _viewModel.operations);
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

  Widget _buildSummaryCard() {
    final total = _viewModel.calculateTotal();

    return Column(
      children: [
        // Виджет погоды
        _buildWeatherCard(),

        // Старая статистика
        Card(
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
                  'Операций: ${_viewModel.operations.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Новый метод для виджета погоды
  Widget _buildWeatherCard() {
    if (_weatherViewModel.isLoading) {
      return Card(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Загрузка погоды...'),
            ],
          ),
        ),
      );
    }

    if (_weatherViewModel.weather == null) {
      return Container(); // Не показываем если нет данных
    }

    final weather = _weatherViewModel.weather!;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Погода в ${weather.city}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _weatherViewModel.refreshWeather,
                  iconSize: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.network(
                  weather.iconUrl,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.wb_sunny, size: 50, color: Colors.orange);
                  },
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.round()}°C',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weather.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '💧 ${weather.humidity.round()}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '💨 ${weather.windSpeed.round()} м/с',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '🚗 ${weather.drivingRecommendation}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[800],
                ),
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
              child: _viewModel.operations.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Нет операций',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _viewModel.operations.length,
                      itemBuilder: (context, index) {
                        final operation = _viewModel.operations[index];
                        return _OperationItem(
                          date: '${operation.date.day}.${operation.date.month}.${operation.date.year}',
                          type: operation.type,
                          amount: '${operation.amount} ₽',
                          comment: operation.comment,
                          onDelete: () {
                            _viewModel.deleteOperation(operation.id);
                          },
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
  final VoidCallback? onDelete;

  const _OperationItem({
    required this.date,
    required this.type,
    required this.amount,
    required this.comment,
    this.onDelete,
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              amount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
                fontSize: 16,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete, size: 18),
                onPressed: onDelete,
                color: Colors.red,
              ),
            ],
          ],
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