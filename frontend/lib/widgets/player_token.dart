import 'dart:math';

import 'package:flutter/material.dart';

class PlayerToken extends StatelessWidget {
  final int index;
  final bool circle;

  const PlayerToken({Key? key, required this.index, required this.circle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Text(circle ? "O" : "X", style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }
}
