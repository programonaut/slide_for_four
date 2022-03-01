import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/connection_visualization.dart';
import 'package:flutter_puzzle_hack/widgets/grid.dart';
import 'package:flutter_puzzle_hack/widgets/room_code.dart';
import 'package:google_fonts/google_fonts.dart';

class Board extends StatelessWidget {
  final List<int> numbers;
  final bool activePlayer;
  final String room;
  final int player;
  final List<bool> changes;
  final bool hideRoom;

  const Board({
    Key? key,
    required this.numbers,
    required this.activePlayer,
    required this.room,
    required this.player,
    required this.changes,
    this.hideRoom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isMobile = false;
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      isMobile = true;
    }
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        activePlayer
                            ? "It's your turn!"
                            : "It's not your turn!",
                        style: TextStyle(
                          fontSize: 36,
                        ),
                      ),
                    ),
                  ),
                  if (isMobile) ...[
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Swipe the white Tiles!",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                  FittedBox(
                    // fit: BoxFit.fitWidth,
                    child: Text(
                      "You are: ${player == 1 ? "O" : "X"}",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
              Grid(
                numbers: numbers,
                changes: changes,
                size: size,
                // clickGrid: clickGrid,
              ),
              if (!hideRoom) ...[
                RoomCode(),
              ] else ...[
                SizedBox.shrink()
              ]
            ],
          ),
          ConnectionVisualization(),
        ],
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