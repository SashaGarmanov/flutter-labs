import 'package:flutter/material.dart';
import '../../domain/models/operation.dart';
import '../view_models/fuel_price_view_model.dart';
import '../../domain/models/fuel_price.dart';

class AddRecordScreen extends StatefulWidget {
  final Function(Operation)? onSave;

  const AddRecordScreen({super.key, this.onSave});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final FuelPriceViewModel _fuelViewModel = FuelPriceViewModel();

  String _selectedType = 'Заправка';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _litersController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  final List<String> _operationTypes = [
    'Заправка',
    'Запчасть',
    'Сервис',
    'Мойка',
  ];

  @override
  void initState() {
    super.initState();
    _fuelViewModel.addListener(_onFuelDataChanged);
  }

  void _onFuelDataChanged() {
    if (_selectedType == 'Заправка' && _litersController.text.isNotEmpty) {
      _calculateAutoAmount();
    }
    setState(() {});
  }

  void _calculateAutoAmount() {
    if (_litersController.text.isNotEmpty) {
      final liters = double.tryParse(_litersController.text);
      if (liters != null && liters > 0) {
        final fuelPrice = _fuelViewModel.getCurrentFuelPrice();
        if (fuelPrice != null) {
          final amount = (fuelPrice.price * liters).round();
          _amountController.text = amount.toString();
        }
      }
    }
  }

  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      final operation = Operation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedType,
        amount: int.tryParse(_amountController.text) ?? 0,
        comment: _commentController.text.isEmpty
            ? _getDefaultComment()
            : _commentController.text,
        date: DateTime.now(),
        mileage: int.tryParse(_mileageController.text),
        liters: _selectedType == 'Заправка' ? double.tryParse(_litersController.text) : null,
      );

      Navigator.pop(context, operation);
    }
  }

  String _getDefaultComment() {
    switch (_selectedType) {
      case 'Заправка':
        final fuelPrice = _fuelViewModel.getCurrentFuelPrice();
        return 'Заправка ${_litersController.text}л ${fuelPrice?.type ?? ''}';
      case 'Запчасть':
        return 'Покупка запчастей';
      case 'Сервис':
        return 'Обслуживание';
      case 'Мойка':
        return 'Мойка автомобиля';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _fuelViewModel.removeListener(_onFuelDataChanged);
    _amountController.dispose();
    _mileageController.dispose();
    _litersController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить запись'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveRecord,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Блок с текущими ценами на топливо
              if (_selectedType == 'Заправка') _buildFuelPriceInfo(),

              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Сумма (₽)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите сумму';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Тип операции',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: _operationTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Выбор типа топлива для заправки
              if (_selectedType == 'Заправка') _buildFuelTypeSelector(),

              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(
                  labelText: 'Пробег (км)',
                  prefixIcon: Icon(Icons.speed),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите пробег';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              if (_selectedType == 'Заправка') ...[
                TextFormField(
                  controller: _litersController,
                  decoration: const InputDecoration(
                    labelText: 'Литры',
                    prefixIcon: Icon(Icons.local_gas_station),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _calculateAutoAmount();
                  },
                  validator: (value) {
                    if (_selectedType == 'Заправка' &&
                        (value == null || value.isEmpty)) {
                      return 'Введите количество литров';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Комментарий',
                  prefixIcon: Icon(Icons.comment),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveRecord,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Сохранить',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFuelPriceInfo() {
    final fuelPrice = _fuelViewModel.getCurrentFuelPrice();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_gas_station, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Топливо: ${fuelPrice?.type ?? 'AI-95'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Цена: ${fuelPrice?.price ?? 0.0} ${fuelPrice?.currency ?? 'RUB'}/л',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Text(
              'АЗС: ${fuelPrice?.station ?? 'Средняя цена'}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFuelTypeSelector() {
    return DropdownButtonFormField<String>(
      value: _fuelViewModel.selectedFuelType,
      decoration: const InputDecoration(
        labelText: 'Тип топлива',
        prefixIcon: Icon(Icons.local_gas_station),
        border: OutlineInputBorder(),
      ),
      items: _fuelViewModel.fuelPrices.map((price) {
        return DropdownMenuItem<String>(
          value: price.type,
          child: Text('${price.type} - ${price.price} ${price.currency}/л'),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          _fuelViewModel.setSelectedFuelType(newValue);
          _calculateAutoAmount();
        }
      },
    );
  }
}