import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/grid.dart';

class Board extends StatelessWidget {
  final List<int> numbers;
  const Board({Key? key, required this.numbers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      color: Colors.white,
      child: Grid(
        numbers: numbers,
        size: size,
        // clickGrid: clickGrid,
      ),
    );
  }
}

  // void clickGrid(int index, int direction) {
  //   print("$index $direction");
  //   int newIndex = direction;

  //   if (index - 1 >= 0 && index % 4 != 0 ||
  //       index + 1 < 16 && (index + 1) % 4 != 0 ||
  //       index - 4 >= 0 ||
  //       index + 4 < 16 ) {
  //     setState(() {
  //       int tmp = widget.numbers[index + direction];
  //       widget.numbers[index + direction] = widget.numbers[index];
  //       widget.numbers[index] = tmp;
  //     });
  //   }
  // }