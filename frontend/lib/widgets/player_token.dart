import 'dart:math';

import 'package:flutter/material.dart';

class PlayerToken extends StatelessWidget {
  final int index;
  final bool circle;

  const PlayerToken(
      {Key? key, required this.index, required this.circle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rand = Random().nextInt(4) + 1;
    return Center(
      child: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
          image: circle ? AssetImage("assets/images/field-circle-$rand.png") : AssetImage("assets/images/field-cross-$rand.png"),
        ),
      ),
        // child: Icon(
        //   circle ? Icons.circle_outlined : Icons.close,
        //   color: circle ? Colors.red : Colors.blue,
        //   size: 64,
        // ),
      ),
    );
  }
}
