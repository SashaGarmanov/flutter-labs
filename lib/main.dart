import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_record_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/brands_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoHelper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
      // Убираем routes, так как используем Navigator.push
    );
  }
}