import '../i_coffee.dart';

// Лабораторная работа 10 — класс Латте
// int milk() => 250 — пример из методических указаний
class Latte implements ICoffee {
  @override
  int coffeBeans() => 50;

  @override
  int milk() => 250;

  @override
  int water() => 100;

  @override
  int cash() => 100;

  @override
  String name() => 'Латте';
}
