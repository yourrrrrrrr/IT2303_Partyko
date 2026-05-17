// Лабораторная работа 10 — класс Resources
// Вынесен из Machine, чтобы избежать антипаттерна God Object
class Resources {
  // Закрытые поля (Лаб 9)
  int _coffeeBeans;
  int _milk;
  int _water;
  int _cash;

  Resources({
    int coffeeBeans = 250,
    int milk = 250,
    int water = 250,
    int cash = 0,
  })  : _coffeeBeans = coffeeBeans,
        _milk = milk,
        _water = water,
        _cash = cash;

  // Геттеры (Лаб 9)
  int get coffeeBeans => _coffeeBeans;
  int get milk => _milk;
  int get water => _water;
  int get cash => _cash;

  // Сеттеры (Лаб 9)
  set coffeeBeans(int v) => _coffeeBeans = v < 0 ? 0 : v;
  set milk(int v) => _milk = v < 0 ? 0 : v;
  set water(int v) => _water = v < 0 ? 0 : v;
  set cash(int v) => _cash = v;

  // Метод setResource (Лаб 9/10) — добавление ресурса
  void addResource(String type, int value) {
    switch (type) {
      case 'milk':
        _milk += value;
        break;
      case 'water':
        _water += value;
        break;
      case 'beans':
        _coffeeBeans += value;
        break;
      case 'cash':
        _cash += value;
        break;
    }
  }

  // Метод getResource (Лаб 9/10) — получение значения ресурса
  int getResource(String type) {
    switch (type) {
      case 'milk':
        return _milk;
      case 'water':
        return _water;
      case 'beans':
        return _coffeeBeans;
      case 'cash':
        return _cash;
      default:
        return 0;
    }
  }

  // Закрытый метод субстракции ресурсов при приготовлении (Лаб 9)
  void subtractResources({
    required int beans,
    required int milkAmt,
    required int waterAmt,
  }) {
    _coffeeBeans = (_coffeeBeans - beans).clamp(0, double.maxFinite.toInt());
    _milk = (_milk - milkAmt).clamp(0, double.maxFinite.toInt());
    _water = (_water - waterAmt).clamp(0, double.maxFinite.toInt());
  }
}
