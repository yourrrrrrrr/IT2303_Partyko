import 'package:flutter/material.dart';
import '../classes/machine.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({Key? key}) : super(key: key);

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final Machine _machine = Machine();

  final _milkCtrl = TextEditingController();
  final _waterCtrl = TextEditingController();
  final _beansCtrl = TextEditingController();
  final _cashCtrl = TextEditingController();

  void _addResource(String type, TextEditingController ctrl, String label) {
    final value = int.tryParse(ctrl.text.trim());
    if (value == null || value <= 0) {
      _showSnackBar('Введите корректное число', isError: true);
      return;
    }
    _machine.fillResources(type, value);
    ctrl.clear();
    _showSnackBar('$label: +$value');
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red[800] : const Color(0xFF5D4037),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _milkCtrl.dispose();
    _waterCtrl.dispose();
    _beansCtrl.dispose();
    _cashCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _machine,
      builder: (context, _) {
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
                    const Text(
                      'Resources',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        _resChip(Icons.water_drop, 'Молоко', '${res.milk} мл'),
                        _resChip(Icons.opacity, 'Вода', '${res.water} мл'),
                        _resChip(Icons.coffee, 'Зерна', '${res.coffeeBeans} г'),
                        _resChip(Icons.payments, 'Касса', '${res.cash} руб.'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Column(
                    children: [
                      _resourceCard(
                        ctrl: _milkCtrl,
                        label: 'Добавить молоко (мл)',
                        type: 'milk',
                        displayLabel: 'Молоко',
                        icon: Icons.water_drop,
                      ),
                      _resourceCard(
                        ctrl: _waterCtrl,
                        label: 'Добавить воду (мл)',
                        type: 'water',
                        displayLabel: 'Вода',
                        icon: Icons.opacity,
                      ),
                      _resourceCard(
                        ctrl: _beansCtrl,
                        label: 'Добавить зерна (г)',
                        type: 'beans',
                        displayLabel: 'Зерна',
                        icon: Icons.coffee,
                      ),
                      _resourceCard(
                        ctrl: _cashCtrl,
                        label: 'Добавить в кассу (руб.)',
                        type: 'cash',
                        displayLabel: 'Касса',
                        icon: Icons.payments,
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

  Widget _resChip(IconData icon, String name, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
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


  Widget _resourceCard({
    required TextEditingController ctrl,
    required String label,
    required String type,
    required String displayLabel,
    required IconData icon,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFD7CCC8),
              child: Icon(icon, color: const Color(0xFF5D4037)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: label,
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
            const SizedBox(width: 10),
            SizedBox(
              width: 48,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _addResource(type, ctrl, displayLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D4037),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}