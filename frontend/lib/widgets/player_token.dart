import 'package:flutter/material.dart';

class PlayerToken extends StatelessWidget {
  final Function click;
  final String text;
  final bool circle;

  const PlayerToken(
      {Key? key, required this.click, required this.text, required this.circle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Center(
          child: Icon(
            circle ? Icons.circle_outlined : Icons.close,
            color: circle ? Colors.red : Colors.blue,
            size: 64,
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(5)),
      ),
      onTap: () => click(),
    );
  }
}
