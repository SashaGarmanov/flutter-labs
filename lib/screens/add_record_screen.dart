import 'package:flutter/material.dart';
import '../models/operation.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
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
        return 'Заправка ${_litersController.text}л';
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

  @override
  void dispose() {
    _amountController.dispose();
    _mileageController.dispose();
    _litersController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}