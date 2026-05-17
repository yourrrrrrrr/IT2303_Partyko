import 'package:flutter/material.dart';
import '../classes/machine.dart';
import '../classes/enums.dart';
import '../classes/i_coffee.dart';
import '../classes/coffee/espresso.dart';
import '../classes/coffee/cappuccino.dart';
import '../classes/coffee/latte.dart';

class CoffeePage extends StatefulWidget {
  const CoffeePage({Key? key}) : super(key: key);

  @override
  State<CoffeePage> createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {
  final Machine _machine = Machine();
  CoffeeType _selectedType = CoffeeType.espresso;
  final TextEditingController _moneyCtrl = TextEditingController();

  ICoffee get _selectedCoffee {
    switch (_selectedType) {
      case CoffeeType.espresso:
        return Espresso();
      case CoffeeType.cappuccino:
        return Cappuccino();
      case CoffeeType.latte:
        return Latte();
    }
  }

  void _addMoney() {
    final value = int.tryParse(_moneyCtrl.text.trim());
    if (value == null || value <= 0) {
      _showSnackBar('Введите корректную сумму', isError: true);
      return;
    }
    _machine.addUserMoney(value);
    _moneyCtrl.clear();
    _showSnackBar('Внесено $value руб.');
  }

  void _withdrawMoney() {
    final change = _machine.withdrawUserMoney();
    if (change > 0) {
      _showSnackBar('Выдано: $change руб.');
    } else {
      _showSnackBar('Нечего возвращать', isError: true);
    }
  }

  Future<void> _makeCoffee() async {
    if (_machine.isMaking) return;
    final result = await _machine.makeCoffeeByType(_selectedCoffee);
    if (mounted) {
      _showSnackBar(result, isError: result.contains('Недостаточно'));
    }
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red[800] : const Color(0xFF5D4037),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _moneyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _machine,
      builder: (context, _) {
        final coffee = _selectedCoffee;
        final res = _machine.resources;

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF7F2EC), Color(0xFFEEE3D8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D4037),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _resourceChip(Icons.coffee, 'Beans', '${res.coffeeBeans} г'),
                        const SizedBox(width: 10),
                        _resourceChip(Icons.water_drop, 'Water', '${res.water} мл'),
                        const SizedBox(width: 10),
                        _resourceChip(Icons.local_drink, 'Milk', '${res.milk} мл'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Coffee Machine',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ваши деньги: ${_machine.userMoney} руб.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Цена: ${coffee.cash()} руб.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.brown[100],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Выберите напиток',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _coffeeCard(
                        CoffeeType.espresso,
                        'Эспрессо',
                        '50 руб. — без молока',
                        Icons.local_cafe,
                      ),
                      _coffeeCard(
                        CoffeeType.cappuccino,
                        'Капучино',
                        '80 руб. — 100 мл молока',
                        Icons.coffee_maker,
                      ),
                      _coffeeCard(
                        CoffeeType.latte,
                        'Латте',
                        '100 руб. — 250 мл молока',
                        Icons.emoji_food_beverage,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _machine.isMaking ? null : _makeCoffee,
                          icon: _machine.isMaking
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.play_arrow),
                          label: Text(
                            _machine.isMaking ? 'Готовлю...' : 'Приготовить',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5D4037),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Оплата',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _moneyCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Внести деньги (руб.)',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.brown.shade200),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _roundActionButton(
                            icon: Icons.attach_money,
                            color: Colors.green,
                            tooltip: 'Внести деньги',
                            onPressed: _addMoney,
                          ),
                          const SizedBox(width: 8),
                          _roundActionButton(
                            icon: Icons.money_off,
                            color: Colors.red,
                            tooltip: 'Забрать сдачу',
                            onPressed: _withdrawMoney,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _coffeeCard(CoffeeType type, String title, String subtitle, IconData icon) {
    final selected = _selectedType == type;
    return Card(
      elevation: selected ? 5 : 2,
      color: selected ? const Color(0xFFD7CCC8) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? const Color(0xFF5D4037) : Colors.transparent,
          width: 1.5,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: RadioListTile<CoffeeType>(
        value: type,
        groupValue: _selectedType,
        activeColor: const Color(0xFF5D4037),
        onChanged: _machine.isMaking ? null : (v) => setState(() => _selectedType = v!),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(subtitle),
        secondary: Icon(icon, color: const Color(0xFF5D4037)),
      ),
    );
  }

  Widget _resourceChip(IconData icon, String name, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            '$name: $value',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _roundActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withValues(alpha: 0.12),
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color),
        ),
      ),
    );
  }
}