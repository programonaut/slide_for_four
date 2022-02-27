import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final text;
  final onPressed;
  final double? fontSize;

  const MenuButton({
    Key? key,
    this.onPressed,
    this.fontSize,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: TextButton(
        onPressed: () => onPressed(),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) return Colors.black;
            if (states.contains(MaterialState.pressed)) return Colors.black;
            return Colors.grey; 
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.transparent;
          }),
        ),
        child: Center(child: Text(text, style: TextStyle(fontSize: fontSize,), textAlign: TextAlign.center,)),
      ),
    );
  }
}