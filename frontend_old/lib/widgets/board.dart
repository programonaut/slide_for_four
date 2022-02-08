import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/grid.dart';

class Board extends StatefulWidget {
  final List<int> numbers;
  const Board({Key? key, required this.numbers}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size.height);
    return Container(
      height: size.height,
      color: Colors.white,
      child: Grid(
        numbers: widget.numbers,
        size: size,
        // clickGrid: clickGrid,
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
        int tmp = widget.numbers[index + direction];
        widget.numbers[index + direction] = widget.numbers[index];
        widget.numbers[index] = tmp;
      });
    }
  }
}
