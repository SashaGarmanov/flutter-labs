import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/operation.dart';

class OperationRepository {
  static final OperationRepository _instance = OperationRepository._internal();
  factory OperationRepository() => _instance;
  OperationRepository._internal();

  static const String _operationsKey = 'operations';
  List<Operation> _memoryOperations = [];
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _loadFromStorage();
      _isInitialized = true;
    }
  }

  Future<void> insertOperation(Operation operation) async {
    await _ensureInitialized();

    try {
      print('🔄 Сохранение операции: ${operation.toMap()}');

      // Добавляем в память
      _memoryOperations.insert(0, operation);

      // Сохраняем в хранилище
      await _saveToStorage();

      print('✅ Операция сохранена. Всего операций: ${_memoryOperations.length}');
    } catch (e) {
      print('❌ Ошибка сохранения операции: $e');
      rethrow;
    }
  }

  Future<List<Operation>> getAllOperations() async {
    await _ensureInitialized();
    print('📊 Загружено операций из памяти: ${_memoryOperations.length}');
    return List.from(_memoryOperations);
  }

  Future<void> deleteOperation(String id) async {
    await _ensureInitialized();

    try {
      _memoryOperations.removeWhere((op) => op.id == id);
      await _saveToStorage();
    } catch (e) {
      print('❌ Ошибка удаления операции: $e');
      rethrow;
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final operationsJson = _memoryOperations.map((op) => json.encode(op.toMap())).toList();
      await prefs.setStringList(_operationsKey, operationsJson);
      print('💾 Данные сохранены в SharedPreferences. Операций: ${_memoryOperations.length}');

      // Дополнительная проверка для веб-версии
      if (_isWeb()) {
        print('🌐 Веб-версия: проверяем сохранение...');
        final verify = prefs.getStringList(_operationsKey);
        print('🌐 Проверка: ${verify?.length ?? 0} записей после сохранения');
      }
    } catch (e) {
      print('❌ Ошибка сохранения в SharedPreferences: $e');
    }
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final operationsJson = prefs.getStringList(_operationsKey) ?? [];

      print('📥 Попытка загрузить из SharedPreferences: ${operationsJson.length} записей');

      _memoryOperations = operationsJson.map((jsonString) {
        try {
          final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
          return Operation.fromMap(jsonMap);
        } catch (e) {
          print('❌ Ошибка парсинга операции: $e');
          print('❌ Проблемный JSON: $jsonString');
          return Operation(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: 'Ошибка',
            amount: 0,
            comment: 'Неверный формат данных',
            date: DateTime.now(),
          );
        }
      }).toList();

      // Сортируем по дате (новые сверху)
      _memoryOperations.sort((a, b) => b.date.compareTo(a.date));

      print('📥 Успешно загружено из SharedPreferences: ${_memoryOperations.length} операций');

      // Отладочный вывод первых 2 операций
      if (_memoryOperations.isNotEmpty) {
        print('📝 Первые 2 операции:');
        for (int i = 0; i < _memoryOperations.length && i < 2; i++) {
          print('  ${i + 1}. ${_memoryOperations[i].toMap()}');
        }
      }
    } catch (e) {
      print('❌ Ошибка загрузки из SharedPreferences: $e');
      _memoryOperations = [];
    }
  }

  bool _isWeb() {
    return identical(0, 0.0);
  }

  // Метод для отладки - посмотреть что вообще есть в SharedPreferences
  Future<void> debugStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    print('🔍 Все ключи в SharedPreferences: $keys');

    final operationsJson = prefs.getStringList(_operationsKey) ?? [];
    print('🔍 Сырые данные операций: $operationsJson');

    if (operationsJson.isNotEmpty) {
      print('🔍 Первая запись в сыром виде: ${operationsJson.first}');
    }
  }
}