import 'package:flutter/material.dart';

class SimpleList extends StatelessWidget {
  const SimpleList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: const [
          ListTile(title: Text('Первая строка')),
          Divider(),
          ListTile(title: Text('Вторая строка')),
          Divider(),
          ListTile(title: Text('Третья строка')),
        ],
    );
  }
}
