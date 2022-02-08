import 'package:flutter/material.dart';

class GridButton extends StatelessWidget {
  final Function click;
  final String text;

  const GridButton({Key? key, required this.click, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.amber,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        color: Colors.black,
      ),
      onTap: () => click(),
    );
  }
}
