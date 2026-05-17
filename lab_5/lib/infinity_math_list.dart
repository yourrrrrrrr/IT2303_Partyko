// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:math';

class InfinityMathList extends StatelessWidget {
  const InfinityMathList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index.isOdd) return Divider();
        int i = index ~/ 2;
        final value = pow(2, i);
        print('i = $i, результат = $value');
        return ListTile(title: Text('2 ^ $i = $value'));
      },
    );
  }
}
