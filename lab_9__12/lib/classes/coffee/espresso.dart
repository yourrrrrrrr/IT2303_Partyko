import '../i_coffee.dart';

// Лабораторная работа 9/10 — класс Эспрессо
// Из метод. указаний: 50 г зерна, 100 мл воды, без молока
class Espresso implements ICoffee {
  @override
  int coffeBeans() => 50;

  @override
  int milk() => 0;

  @override
  int water() => 100;

  @override
  int cash() => 50;

  @override
  String name() => 'Эспрессо';
}
