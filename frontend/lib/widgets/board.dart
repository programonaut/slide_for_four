import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/grid.dart';

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

  @override
  void initState() {
    super.initState();
    numbers.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size.height);
    return Container(
      height: size.height,
      color: Colors.white,
      child: Grid(
        numbers: numbers,
        size: size,
        clickGrid: clickGrid,
      ),
    );
  }

  void clickGrid(int index, int direction) {
    print("$index $direction");
    int newIndex = direction;

    if (index - 1 >= 0 && index % 4 != 0 ||
        index + 1 < 16 && (index + 1) % 4 != 0 ||
        index - 4 >= 0 ||
        index + 4 < 16 ) {
      setState(() {
        int tmp = numbers[index + direction];
        numbers[index + direction] = numbers[index];
        numbers[index] = tmp;
      });
    }
  }
}
