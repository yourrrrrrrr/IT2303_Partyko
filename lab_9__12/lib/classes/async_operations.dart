// Лабораторная работа 11 — асинхронные операции
// Вынесены в отдельный файл согласно заданию

class AsyncOperations {
  /// Главный метод запуска приготовления.
  /// Вызывается из фабричного конструктора Machine (Лаб 11, п.7).
  static Future<void> makeCoffee(bool withMilk) async {
    print('*-----------------------------*');
    print('_start_');

    if (withMilk) {
      // Нагрев воды и взбивание молока — параллельно (Лаб 11, п.4)
      await Future.wait([
        _heatWater(),
        _frothMilk(),
      ]);
      print('_then_');
      // Заваривание и смешивание (Лаб 11, п.3 + п.5)
      await _brewCoffee(withMilk: true);
    } else {
      // Без молока — сначала вода, затем заваривание (Лаб 11, п.2 + п.3)
      await _heatWater();
      print('_then_');
      await _brewCoffee(withMilk: false);
    }

    print('_end_');
  }

  // Лаб 11, п.2 — нагрев воды, задержка 3 сек
  static Future<void> _heatWater() async {
    print('start_process: water');
    await Future.delayed(const Duration(seconds: 3));
    print('done_process: water');
  }

  // Лаб 11, п.4 — взбивание молока, задержка 5 сек
  static Future<void> _frothMilk() async {
    print('start_process: milk');
    await Future.delayed(const Duration(seconds: 5));
    print('done_process: milk');
  }

  // Лаб 11, п.3 — заваривание кофе, задержка 5 сек
  // Лаб 11, п.5 — если с молоком, включает смешивание (+3 сек итого)
  static Future<void> _brewCoffee({required bool withMilk}) async {
    print('start_process: espresso');
    await Future.delayed(const Duration(seconds: 5));
    if (withMilk) {
      print('done_process: coffee with milk');
    } else {
      print('done_process: coffee with water');
    }
  }
}
