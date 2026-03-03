// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class InfinityList extends StatelessWidget {
  const InfinityList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) {
          if (index.isOdd) return Divider();
          int i = index ~/ 2;
          print('i = $i');
          return ListTile(
            title: Text('Строка № $i'),
          );
        },
    );
  }
}