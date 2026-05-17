import 'package:flutter/material.dart';
import 'pages/coffee_page.dart';
import 'pages/resources_page.dart';

void main() {
  runApp(const CoffeeMachineApp());
}

class CoffeeMachineApp extends StatelessWidget {
  const CoffeeMachineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const seed = Colors.brown;

    return MaterialApp(
      title: 'Coffee Machine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F2EC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5D4037),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF5D4037),
          unselectedItemColor: Color(0xFF8D8D8D),
          type: BottomNavigationBarType.fixed,
          elevation: 12,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    CoffeePage(),
    ResourcesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Machine'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: const Color(0xFF5D4037),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            onTap: (i) => setState(() => _currentIndex = i),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.coffee),
                label: 'Кофе',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2),
                label: 'Ресурсы',
              ),
            ],
          ),
        ),
      ),
    );
  }
}