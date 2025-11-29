import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_record_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/brands_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoHelper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(), // Главный экран как точка входа
    );
  }
}