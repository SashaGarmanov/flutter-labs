import 'package:flutter/material.dart';

class AddRecordScreen extends StatelessWidget {
  const AddRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить запись'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: AddRecordForm(),
      ),
    );
  }
}

class AddRecordForm extends StatefulWidget {
  const AddRecordForm({super.key});

  @override
  State<AddRecordForm> createState() => _AddRecordFormState();
}

class _AddRecordFormState extends State<AddRecordForm> {
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Поле для ввода суммы
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

          // Выбор типа операции
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

          // Поле для ввода пробега
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

          // Поле для ввода литров (только для заправки)
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

          // Текстовое поле для комментария
          TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Комментарий',
              prefixIcon: Icon(Icons.comment),
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),

          // Кнопка сохранения
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Логика сохранения будет добавлена позже
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Запись сохранена')),
                  );
                }
              },
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