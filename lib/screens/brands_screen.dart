import 'package:flutter/material.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  final List<Map<String, dynamic>> _allBrands = [
    {'name': 'Audi', 'country': 'Germany', 'founded': 1909},
    {'name': 'BMW', 'country': 'Germany', 'founded': 1916},
    {'name': 'Mercedes-Benz', 'country': 'Germany', 'founded': 1926},
    {'name': 'Volkswagen', 'country': 'Germany', 'founded': 1937},
    {'name': 'Toyota', 'country': 'Japan', 'founded': 1937},
    {'name': 'Honda', 'country': 'Japan', 'founded': 1948},
    {'name': 'Nissan', 'country': 'Japan', 'founded': 1933},
    {'name': 'Ford', 'country': 'USA', 'founded': 1903},
    {'name': 'Chevrolet', 'country': 'USA', 'founded': 1911},
    {'name': 'Tesla', 'country': 'USA', 'founded': 2003},
    {'name': 'Hyundai', 'country': 'South Korea', 'founded': 1967},
    {'name': 'Kia', 'country': 'South Korea', 'founded': 1944},
    {'name': 'Lada', 'country': 'Russia', 'founded': 1966},
    {'name': 'Renault', 'country': 'France', 'founded': 1899},
    {'name': 'Peugeot', 'country': 'France', 'founded': 1810},
    {'name': 'Fiat', 'country': 'Italy', 'founded': 1899},
    {'name': 'Ferrari', 'country': 'Italy', 'founded': 1939},
    {'name': 'Lamborghini', 'country': 'Italy', 'founded': 1963},
  ];

  List<Map<String, dynamic>> _filteredBrands = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredBrands = _allBrands;
    _searchController.addListener(_filterBrands);
  }

  void _filterBrands() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBrands = _allBrands.where((brand) {
        final brandName = brand['name'].toString().toLowerCase();
        final country = brand['country'].toString().toLowerCase();
        return brandName.contains(query) || country.contains(query);
      }).toList();
    });
  }

  String _getFlagEmoji(String country) {
    switch (country) {
      case 'Germany':
        return '🇩🇪';
      case 'Japan':
        return '🇯🇵';
      case 'USA':
        return '🇺🇸';
      case 'South Korea':
        return '🇰🇷';
      case 'Russia':
        return '🇷🇺';
      case 'France':
        return '🇫🇷';
      case 'Italy':
        return '🇮🇹';
      default:
        return '🏳️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бренды авто'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Поисковая строка
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск марок...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),

          // Информация о количестве
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Найдено марок: ${_filteredBrands.length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Список брендов
          Expanded(
            child: _filteredBrands.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Марки не найдены',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredBrands.length,
                    itemBuilder: (context, index) {
                      final brand = _filteredBrands[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                brand['name'].toString().substring(0, 1),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            brand['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            '${brand['country']} • Основан в ${brand['founded']}',
                          ),
                          trailing: Text(
                            _getFlagEmoji(brand['country']),
                            style: const TextStyle(fontSize: 20),
                          ),
                          onTap: () {
                            // Действие при выборе бренда
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Выбрана марка: ${brand['name']}'),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}