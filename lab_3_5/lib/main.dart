import 'package:flutter/material.dart';
import 'simple_list.dart';
import 'infinity_list.dart';
import 'infinity_math_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Этот виджет является корневой папкой вашего приложения.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторная работа №3 (5)',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4cb050),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Список элементов'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _currentWidget = const Center(
    child: Text('Выберите список', style: TextStyle(fontSize: 28)),
  );

  void _back() {
    setState(() {
      _currentWidget = const Center(child: Text('Выберите список'));
    });
  }

  void _showSimple() {
    setState(() {
      _currentWidget = const SimpleList();
    });
  }

  void _showInfinity() {
    setState(() {
      _currentWidget = const InfinityList();
    });
  }

  void _showMath() {
    setState(() {
      _currentWidget = const InfinityMathList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF4cb050),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10) ,
            child: Wrap(
              spacing: 10, // расстояние между кнопками по горизонтали
              runSpacing: 5, // расстояние между строками
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _showSimple,
                  child: const Text('Простой'),
                ),
                ElevatedButton(
                  onPressed: _showInfinity,
                  child: const Text('Бесконечный'),
                ),
                ElevatedButton(
                  onPressed: _showMath,
                  child: const Text('Степени 2'),
                ),
              ],
            ),
          ),
          Flexible(child: _currentWidget),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(onPressed: _back, child: const Text('Домой')),
      ),
    );
  }
}
