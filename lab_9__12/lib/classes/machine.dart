import 'package:flutter/foundation.dart';
import 'resources.dart';
import 'i_coffee.dart';
import 'async_operations.dart';

// Лабораторные 9, 10, 11
// Паттерн Одиночка (Singleton) — Лаб 10
// ChangeNotifier — чтобы UI автоматически обновлялся при изменении состояния
class Machine extends ChangeNotifier {
  // ── Singleton ──────────────────────────────────────────────
  static final Machine _instance = Machine._internal();

  // Фабричный конструктор (Лаб 10) — возвращает единственный экземпляр
  factory Machine() => _instance;

  Machine._internal() : _resources = Resources();

  // ── Поля (Лаб 9) ───────────────────────────────────────────
  // В Лаб 10 ресурсы вынесены в отдельный класс Resources
  final Resources _resources;
  int _userMoney = 0;  // деньги, внесённые пользователем
  bool _isMaking = false; // флаг — идёт ли приготовление

  // ── Геттеры (Лаб 9) ────────────────────────────────────────
  Resources get resources => _resources;
  int get userMoney => _userMoney;
  bool get isMaking => _isMaking;

  // ── Работа с деньгами пользователя (Лаб 9) ─────────────────

  /// Внести деньги в машину
  void addUserMoney(int amount) {
    if (amount <= 0) return;
    _userMoney += amount;
    notifyListeners();
  }

  /// Забрать сдачу / вернуть деньги
  int withdrawUserMoney() {
    final change = _userMoney;
    _userMoney = 0;
    notifyListeners();
    return change;
  }

  // ── Работа с ресурсами (Лаб 9/10) ──────────────────────────

  /// setResource — добавление ресурса в машину (Лаб 9)
  void fillResources(String type, int value) {
    _resources.addResource(type, value);
    notifyListeners();
  }

  // ── Проверка ресурсов (Лаб 9) ──────────────────────────────

  /// isAvailableResources / isAvailable (Лаб 9)
  bool isAvailableResources(ICoffee coffee) {
    return _resources.coffeeBeans >= coffee.coffeBeans() &&
        _resources.milk >= coffee.milk() &&
        _resources.water >= coffee.water();
  }

  // ── Приготовление кофе (Лаб 9, 10, 11) ────────────────────

  /// makingCoffee (Лаб 9) → makeCoffeeByType (Лаб 10)
  /// Публичный метод, использует фабричный шаблон через ICoffee (Лаб 10)
  /// Содержит вызов асинхронных операций из AsyncOperations (Лаб 11)
  Future<String> makeCoffeeByType(ICoffee coffee) async {
    // Проверка денег
    if (_userMoney < coffee.cash()) {
      return 'Недостаточно средств!\n'
          'Нужно ${coffee.cash()} руб., у вас $_userMoney руб.';
    }

    // isAvailableResources (Лаб 9)
    if (!isAvailableResources(coffee)) {
      final missing = <String>[];
      if (_resources.coffeeBeans < coffee.coffeBeans()) {
        missing.add(
            '• Зерна: нужно ${coffee.coffeBeans()} г, есть ${_resources.coffeeBeans} г');
      }
      if (_resources.milk < coffee.milk()) {
        missing.add(
            '• Молоко: нужно ${coffee.milk()} мл, есть ${_resources.milk} мл');
      }
      if (_resources.water < coffee.water()) {
        missing.add(
            '• Вода: нужно ${coffee.water()} мл, есть ${_resources.water} мл');
      }
      return 'Недостаточно ресурсов:\n${missing.join('\n')}';
    }

    _isMaking = true;
    notifyListeners();

    // Лаб 11 — вызов асинхронных операций (п.7 — из фабричного конструктора)
    await AsyncOperations.makeCoffee(coffee.milk() > 0);

    // substractResources (Лаб 9) — закрытый метод в Resources
    _resources.subtractResources(
      beans: coffee.coffeBeans(),
      milkAmt: coffee.milk(),
      waterAmt: coffee.water(),
    );

    // Оплата
    _userMoney -= coffee.cash();
    _resources.cash += coffee.cash();

    _isMaking = false;
    notifyListeners();

    return '${coffee.name()} готово! \nСдача: $_userMoney руб.';
  }
}
