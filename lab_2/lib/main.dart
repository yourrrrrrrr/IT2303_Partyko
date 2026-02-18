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
      title: 'Flutter Demo',
      theme: ThemeData(
        // Это тема вашего приложения.

        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 62, 183, 58)),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // Этот виджет является домашней страницей вашего приложения. Это состояние, означающее
  // что у него есть объект состояния (определенный ниже), который содержит поля, влияющие
  // как это выглядит.

  // Этот класс является конфигурацией для состояния. Он содержит значения (в данном случае 
  // название), предоставленные родительским элементом (в данном случае виджетом приложения) и
  // используемые методом построения состояния. Поля в подклассе Widget
  //всегда помечены как "final".
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
  // Этот метод запускается повторно при каждом вызове setState, например, как это сделано
  // с помощью метода _incrementCounter, описанного выше.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Здесь мы берем значение из объекта MyHomePage, который был создан с помощью
        // метода App.build, и используем его для установки заголовка нашей панели приложений.
        title: Text(widget.title),
      ),
      body: Center(
  // Center - это виджет макета. Он берет один дочерний элемент и размещает его
  // в середине родительского.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
