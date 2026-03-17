import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Этот виджет является корневой папкой вашего приложения.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторная работа №4 (6)',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4cb050),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const MainScreen(title: 'Возвращение значения'),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _screen2() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SecondScreen(title: 'Выберите любой вариант'),
      ),
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF4cb050),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _screen2(),
          child: const Text('Открыть второе окно'),
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key, required this.title});
  final String title;

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF4cb050),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'Да!'),
              child: const Text('Да!'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'Нет...'),
              child: const Text('Нет...'),
            ),
          ],
        ),
      ),
    );
  }
}
