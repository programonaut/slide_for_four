import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/connection_visualization.dart';
import 'package:flutter_puzzle_hack/widgets/grid.dart';
import 'package:google_fonts/google_fonts.dart';

class Board extends StatelessWidget {
  final List<int> numbers;
  final bool activePlayer;
  final String room;
  final int player;

  const Board(
      {Key? key,
      required this.numbers,
      required this.activePlayer,
      required this.room,
      required this.player})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  activePlayer
                      ? "It's your turn!"
                      : "It's your opponents turn!",
                  style: TextStyle(
                    fontSize: 36,
                  ),
                ),
                Text(
                  "You are: ${player == 1 ? "O" : "X"}",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            Grid(
              numbers: numbers,
              size: size,
              // clickGrid: clickGrid,
            ),
            SelectableText(
              "Room code: $room",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        ConnectionVisualization(),
      ],
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