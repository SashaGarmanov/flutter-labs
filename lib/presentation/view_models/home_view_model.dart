import 'package:flutter/foundation.dart';
import '../../data/repositories/operation_repository.dart';
import '../../data/services/local_storage_service.dart';
import '../../domain/models/operation.dart';

class HomeViewModel with ChangeNotifier {
  final OperationRepository _operationRepository = OperationRepository();
  final LocalStorageService _localStorage = LocalStorageService();

  List<Operation> _operations = [];
  bool _isLoading = false;
  int _lastMileage = 0;
  bool _sampleDataAdded = false;

  List<Operation> get operations => _operations;
  bool get isLoading => _isLoading;
  int get lastMileage => _lastMileage;

  HomeViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Загружаем операции из хранилища
      _operations = await _operationRepository.getAllOperations();
      _lastMileage = _localStorage.getLastMileage();

      print('✅ Загружено операций: ${_operations.length}');

      // ТОЛЬКО для отладки: если операций нет, добавляем тестовые
      if (_operations.isEmpty) {
        print('📝 Нет операций, добавляем тестовые данные...');
        await _addSampleData();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка загрузки данных: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _addSampleData() async {
    final sampleOperations = [
      Operation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'Заправка',
        amount: 3500,
        comment: 'АИ-95, 40л',
        date: DateTime.now().subtract(Duration(days: 5)),
        mileage: 150000,
        liters: 40,
      ),
      Operation(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        type: 'Сервис',
        amount: 5000,
        comment: 'Замена масла',
        date: DateTime.now().subtract(Duration(days: 10)),
        mileage: 149800,
      ),
    ];

    for (final operation in sampleOperations) {
      await addOperation(operation);
    }
  }

  Future<void> addOperation(Operation operation) async {
    try {
      print('🔄 Добавление операции: ${operation.type}');
      await _operationRepository.insertOperation(operation);

      if (operation.mileage != null) {
        await _localStorage.saveLastMileage(operation.mileage!);
        _lastMileage = operation.mileage!;
      }

      _operations.insert(0, operation);
      notifyListeners();

      print('✅ Операция добавлена. Всего операций: ${_operations.length}');
    } catch (e) {
      print('❌ Ошибка добавления операции: $e');
      rethrow;
    }
  }

  Future<void> deleteOperation(String id) async {
    try {
      await _operationRepository.deleteOperation(id);
      _operations.removeWhere((op) => op.id == id);
      notifyListeners();
    } catch (e) {
      print('❌ Ошибка удаления операции: $e');
      rethrow;
    }
  }

  int calculateTotal() {
    return _operations.fold(0, (sum, operation) => sum + operation.amount);
  }

  // Метод для отладки
  Future<void> debugStorage() async {
    await _operationRepository.debugStorage();
  }
}