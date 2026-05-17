import '../i_coffee.dart';

// Лабораторная работа 10 — класс Капучино
class Cappuccino implements ICoffee {
  @override
  int coffeBeans() => 50;

  @override
  int milk() => 100; // взбитое молоко

  @override
  int water() => 100;

  @override
  int cash() => 80;

  @override
  String name() => 'Капучино';
}
